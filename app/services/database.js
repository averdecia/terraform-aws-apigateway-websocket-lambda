const {DynamoDBClient, PutItemCommand, DeleteItemCommand, ScanCommand } = require("@aws-sdk/client-dynamodb");
const { DataSuccess, DataError } = require("../utils/data");
const { ERRORS } = require("../utils/events");
const { Logger } = require("../utils/logger");

const TTL = 3600 * 1000 // 1 hour
const {DYNAMODB_CONNECTIONS_TABLE, REGION} = process.env
const dbClient = new DynamoDBClient({ region: REGION});

exports.DatabaseHandler = {
    Save: async (connectionId, phone) => {
        const params = {
            TableName: DYNAMODB_CONNECTIONS_TABLE,
            Item:{
                connectionId: {S: connectionId},
                phone: {N: phone},
                deleteAt: {N: (Date.now() + TTL).toString()},
            }
        };

        try {
            await dbClient.send(new PutItemCommand(params))
            return DataSuccess(params.Item)
        } catch (error) {
            Logger.debug(ERRORS.UNABLE_TO_SAVE_IN_DATABASE, error)
            return DataError(error.message)
        }
    },
    Delete: async (connectionId) => {
        const params = {
            TableName: DYNAMODB_CONNECTIONS_TABLE,
            Key:{
                connectionId: {S: connectionId}
            }
        };

        try {
            await dbClient.send(new DeleteItemCommand(params))
            return DataSuccess(params.Item)
        } catch (error) {
            Logger.debug(ERRORS.UNABLE_TO_DELETE_FROM_DATABASE, error)
            return DataError(error.message)
        }
    },
    GetConnectionsByPhone: async (phone) => {
        const params = {
            TableName: DYNAMODB_CONNECTIONS_TABLE,
            // Specify which items in the results are returned.
            FilterExpression: "phone = :phone",
            // Define the expression attribute value, which are substitutes for the values you want to compare.
            ExpressionAttributeValues: {
              ":phone": { N: phone }
            },
            // Set the projection expression, which the the attributes that you want.
            ProjectionExpression: "connectionId, phone"
          };

        try {
            const data = await dbClient.send(new ScanCommand(params))
            return DataSuccess(data.Items)
        } catch (error) {
            Logger.debug(ERRORS.UNABLE_TO_SCAN_FROM_DATABASE, error)
            return DataError(error.message)
        }
    }
}