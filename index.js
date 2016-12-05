const readline = require('readline');
const sse = require("sse-node");
const app = require("express")();
const rl = readline.createInterface({
  input: process.stdin
});

var clients = [];

rl.on('line', (input) => {
  clients.forEach(function(client) {
    client.send(input);
  });
});

app.all('/', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
 });

app.get("/", (req, res) => {
    const client = sse(req, res);
    clients.push(client);
    client.onClose(() => {
    	var index = clients.indexOf(client);
    	if (index > -1) {
    		clients.splice(index, 1);
		}
    });
});

// TODO use commander to parse port: node index.js --port=9000
app.listen(process.argv[2] || 3000);
