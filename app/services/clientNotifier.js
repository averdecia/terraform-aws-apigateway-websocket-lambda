const { ApiGatewayManagementApiClient, PostToConnectionCommand } = require("@aws-sdk/client-apigatewaymanagementapi");
const { HttpRequest } = require("@aws-sdk/protocol-http");
const { DataSuccess, DataError } = require("../utils/data");
const { ERRORS } = require("../utils/events");
const { Logger } = require("../utils/logger");


const {REGION, APIGATEWAY_WS_URL, APIGATEWAY_WS_STAGE} = process.env
const client = new ApiGatewayManagementApiClient({
    region: REGION,
    endpoint: `https://${APIGATEWAY_WS_URL}/${APIGATEWAY_WS_STAGE}`
});

client.middlewareStack.addRelativeTo(
    (next, context) => {
        return async function (args) {
            if (!HttpRequest.isInstance(args.request)) return next(args);
            let prefixedRequest = args.request.clone();
            if (!prefixedRequest.path.startsWith(`/${APIGATEWAY_WS_STAGE}`)) {
                prefixedRequest.path = `/${APIGATEWAY_WS_STAGE}${args.request.path}`;
            }
            return await next({
                ...args,
                request: prefixedRequest
            });
        };
    },
    {
        relation: "before",
        toMiddleware: "awsAuthMiddleware"
    }
);

exports.ClientNotifier = {
    Notify: async (connectionId, data) => {
        const params = {
            ConnectionId: connectionId,
            Data: JSON.stringify(data)
        }
        try {
            await client.send(new PostToConnectionCommand(params))
            return DataSuccess(connectionId)
        } catch (error) {
            console.log(error)
            Logger.debug(ERRORS.UNABLE_TO_NOTIFY_CLIENT, error)
            return DataError(error.message)
        }
    }
}