const port = 34263;
const WebSocket = require('ws');
const open = require('opn');
const wss = new WebSocket.Server({ port });

console.log(`${new Date()} Server is listening on port ${port}`);

wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(data) {
        wss.clients.forEach(function each(client) {
            if (client !== ws && client.readyState === WebSocket.OPEN) {
                client.send(data);
            }
        });
    });
});

open(`file://${__dirname}/www/index.html`);
