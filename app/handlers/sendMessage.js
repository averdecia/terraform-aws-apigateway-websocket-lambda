const { SuccessResp, ErrorResp, HTTP_STATUS } = require("../utils/http")
const { GetJSONBody } = require("../utils/data")
const { Logger } = require("../utils/logger")
const { EVENTS } = require("../utils/events")
const { DatabaseHandler } = require("../services/database")

exports.handler =  async function(event, context) {
    const { connectionId } = event.requestContext

    const body = GetJSONBody(event)
    if(body.error){
        return ErrorResp(HTTP_STATUS.BAD_REQUEST, body.error.message)
    }

    const { phone } = body.payload

    const dataDB = await DatabaseHandler.Save(connectionId, phone);
    if(dataDB.error){
        return ErrorResp(HTTP_STATUS.INTERNAL_SERVER_ERROR, dataDB.error.message)
    }

    Logger.info(EVENTS.SAVED_IN_DB, {dataDB})
    return SuccessResp(dataDB.payload)
}