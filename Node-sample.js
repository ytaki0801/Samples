const HTTP = require('http');

const HOST = 'localhost';
const PORT = 8080;

const SERVER = HTTP.createServer((request, response) => {
  response.statusCode = 200;
  response.setHeader('Content-Type', 'text/plain');
  response.end('Hello, New World');
});

SERVER.listen(PORT, HOST, () => {});
