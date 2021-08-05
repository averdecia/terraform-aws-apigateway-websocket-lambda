const { SuccessResp } = require("../utils/http")

exports.handler =  async function(event, context) {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2))
    return SuccessResp(context.logStreamName)
}