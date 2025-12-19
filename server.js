const http = require('http');

const hostname = '0.0.0.0'; // Listen on all interfaces
const port = 3000;

const server = http.createServer((req, res) => {
  if (req.url === '/data' && req.method === 'GET') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({
      message: 'Halo teman, waktunya makan siang!',
      status: 'success',
      timestamp: new Date().toISOString()
    }));
    console.log(`[${new Date().toISOString()}] Handled GET /data from ${req.socket.remoteAddress}`);
  } else {
    res.statusCode = 404;
    res.end('Not Found');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
  console.log('Ensure your Android device is on the same network and uses the PC IP.');
});
