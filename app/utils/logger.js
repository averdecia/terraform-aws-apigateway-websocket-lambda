exports.Logger = {
    info: (event, data)=> {
        console.info(`EVENT ${event}: \n` + 
        (typeof data === 'object' && data) ? JSON.stringify(data, null, 2) : data)
    },
    debug: (event, data)=> {
        console.debug(`EVENT ${event}: \n` + 
        (typeof data === 'object' && data) ? JSON.stringify(data, null, 2) : data)
    },
    error: (event, data)=> {
        console.error(`EVENT ${event}: \n` + 
        (typeof data === 'object' && data) ? JSON.stringify(data, null, 2) : data)
    }
}