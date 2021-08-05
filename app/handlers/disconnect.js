const { SuccessResp, ErrorResp, HTTP_STATUS } = require("../utils/http")
const { Logger } = require("../utils/logger")
const { EVENTS } = require("../utils/events")
const { DatabaseHandler } = require("../services/database")

exports.handler =  async function(event, context) {
    const { connectionId } = event.requestContext

    const dataDB = await DatabaseHandler.Delete(connectionId);
    if(dataDB.error){
        return ErrorResp(HTTP_STATUS.INTERNAL_SERVER_ERROR, dataDB.error.message)
    }

    Logger.info(EVENTS.DELETED_FROM_DB, {dataDB})
    return SuccessResp(dataDB.payload)
}