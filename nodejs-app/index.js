const http = require('http');

http.createServer((req, res) => {
  res.write("DevOps Project 1 Working 🚀");
  res.end();
}).listen(3000);
