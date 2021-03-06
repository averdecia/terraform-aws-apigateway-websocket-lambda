exports.EVENTS = {
    SAVED_IN_DB : "SAVED_IN_DB",
    DELETED_FROM_DB : "DELETED_FROM_DB",
    CLIENTS_TO_NOTIFY : "CLIENTS_TO_NOTIFY",
    MESSAGE_QUEUED : "MESSAGE_QUEUED",
    MESSAGE_NOT_QUEUED : "MESSAGE_NOT_QUEUED",
    UNSBLE_TO_FIND_CONNECTIONS : "UNSBLE_TO_FIND_CONNECTIONS"
}

exports.ERRORS = {
    UNABLE_TO_SAVE_IN_DATABASE: "UNABLE_TO_SAVE_IN_DATABASE",
    UNABLE_TO_DELETE_FROM_DATABASE: "UNABLE_TO_DELETE_FROM_DATABASE",
    UNABLE_TO_NOTIFY_CLIENT: "UNABLE_TO_NOTIFY_CLIENT",
    UNABLE_TO_SCAN_FROM_DATABASE: "UNABLE_TO_SCAN_FROM_DATABASE",
    UNABLE_TO_QUEUE_MESSAGE: "UNABLE_TO_QUEUE_MESSAGE",
}

exports.NOTIFICATION_TYPES = {
    NOTIFY: "notify",
    DELETE: "delete",
    NOTIFY_DELETE: "notify_delete",
}