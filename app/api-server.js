// Minimal real server. Prints a line once it is actually listening so
// scripts can confirm it started before anything else depends on it.
const http = require('node:http');

const server = http.createServer((req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify({ ok: true }) + '\n');
});

server.listen(3000, () => console.log('api-server listening on 3000'));
