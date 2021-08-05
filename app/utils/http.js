exports.SuccessResp = (data) => {
    return {
        statusCode: 200,
        // headers: 
        body: JSON.stringify(data ? data : {})
    }
}

exports.ErrorResp = (code, message, data) => {
    return {
        statusCode: code,
        // headers: 
        body: JSON.stringify({
            message,
            data
        })
    }
}

exports.HTTP_STATUS = {
    BAD_REQUEST: 400,
    INTERNAL_SERVER_ERROR: 500
}
