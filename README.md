# terraform-aws-apigateway-websocket-lambda

The repo creates a demo example of Terraform y AWS. The goal is to create a websocket comunication between a frontend an a backend. The frontend will hold the web socket only to receive notifications from any component that executes the notification API.

The comunication diagram is the follow:
![alt text](./docs/diagram.jpg?raw=true)

Once you run terraform the output will show the following variables:
sqs_url = "The url to the Amazon Simple Queue that you just created" // information only
ws_queue_rest_endpoint = "The url to the endpoint to notify information to the clients"
ws_url = "The web socket url to connect from clients"

## Usage
Once yo connect from the clients, you must send the information to filter, in this demos a phone number is used as the linking parameter.
From the client side you can use the https://github.com/ticofab/simple-websocket-client
On connection open you can send a message with the following structure (the action sendMessage is mandatory, its use to detect the lambda to trigger):
```javascript
window.myWebSocket.send("{\"action\":\"sendMessage\",\"payload\":{\"phone\":\"525555555555\"}}")
```
That will create an element in dynamo db to link the phone with the connectionId.

From the backend side, the enpoint should be requested, using a post request with the following body structure:
```javascript
{
    "payload": {
        "type": "notify_delete",
        "phone": "525555555555",
        "data": "otherfield"
    } 
}
```

The type can by, notify, delete, or notify_delete. The delete side will remove the connection from dynamoDB, the notify type, will forward the payload to the client. 
