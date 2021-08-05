const { SuccessResp, ErrorResp, HTTP_STATUS } = require("../utils/http")
const { GetJSONBody } = require("../utils/data")
const { Logger } = require("../utils/logger")
const { EVENTS, NOTIFICATION_TYPES } = require("../utils/events")
const { DatabaseHandler } = require("../services/database")
const { ClientNotifier } = require("../services/clientNotifier")

exports.handler =  async function(event, context) {
    await Promise.all(event.Records.map(async (element) => {
        const body = GetJSONBody(element, "body")
        if(body.error){
            Logger.error(EVENTS.UNABLE_TO_NOTIFY, body.error)
        } else{
            await NotifyAsync(body)
        }
    }))
    return SuccessResp()
}


const NotifyAsync = async (body) => {

    const { phone, type } = body.payload
    const dataDB = await DatabaseHandler.GetConnectionsByPhone(phone);
    if(dataDB.error){
        Logger.error(EVENTS.UNSBLE_TO_FIND_CONNECTIONS, dataDB.error.message)
    }

    const clientsConnections = [];
    await Promise.all(dataDB.payload.map(async (item) => {
        if (type === NOTIFICATION_TYPES.NOTIFY ||  type === NOTIFICATION_TYPES.NOTIFY_DELETE){
            await ClientNotifier.Notify(item.connectionId.S, body.payload)
        }
        if (type === NOTIFICATION_TYPES.DELETE ||  type === NOTIFICATION_TYPES.NOTIFY_DELETE){
            await DatabaseHandler.Delete(item.connectionId.S)
        }
        clientsConnections.push(item.connectionId.S)
    }))
    Logger.info(EVENTS.CLIENTS_TO_NOTIFY, {clientsConnections})
}