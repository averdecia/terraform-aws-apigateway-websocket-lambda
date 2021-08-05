const { Logger } = require("./logger")

exports.GetJSONBody = (event, key) => {
    try {
        console.log(event.body)
        let body = JSON.parse(event.body)
        if(key){
            body = body[key]
        }
        if (!body.payload)
            return this.DataError("Invalid message")
        return this.DataSuccess(body.payload)
    } catch (error) {
        return this.DataError("Invalid message")
    }
}

exports.DataError = (message) => ({
    payload: undefined,
    error: new Error(message)
})

exports.DataSuccess = (payload) => ({
    payload,
    error: undefined
})



exports.ErrorHandler = async (func) => {
    try {
        console.log("antes")
        let result = this.DataSuccess(await func())

        console.log("despues", result)
        return result
    } catch (error) {

        console.log("catch", error.message)
        Logger.error("Internal Error", error)
        return this.DataError(error.message)
    }
}