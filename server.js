const http = require('http');
const fs = require('fs');
const path = require('path');
const log = (msg) => { const line = '[' + new Date().toISOString() + '] ' + msg; console.log(line); fs.appendFileSync('C:\\\\Users\\\\nbhh\\\\Documents\\\\Codex\\\\2026-06-11\\\\goal\\\\outputs\\\\server.log', line + '\n'); };
const dir = 'C:\\Users\\nbhh\\Documents\\Codex\\2026-06-11\\goal\\outputs';
// Clear log
fs.writeFileSync('C:\\\\Users\\\\nbhh\\\\Documents\\\\Codex\\\\2026-06-11\\\\goal\\\\outputs\\\\server.log', 'Server started\n');
const server = http.createServer((req, res) => {
  let urlPath = req.url.split('?')[0];
  if (urlPath === '/') urlPath = '/wheel.html';
  const filePath = path.join(dir, decodeURIComponent(urlPath));
  log('REQ: ' + req.method + ' ' + req.url + ' -> ' + filePath);
  log('  Headers: ' + JSON.stringify({host: req.headers.host, 'user-agent': req.headers['user-agent']}));
  try {
    const data = fs.readFileSync(filePath);
    const ext = path.extname(filePath).toLowerCase();
    const ct = ext === '.html' ? 'text/html; charset=utf-8' : ext === '.js' ? 'application/javascript' : 'text/plain';
    res.writeHead(200, {'Content-Type': ct});
    res.end(data);
    log('  200 OK: ' + data.length + ' bytes');
  } catch(e) {
    log('  404: ' + e.message);
    res.writeHead(404, {'Content-Type': 'text/plain'});
    res.end('Not found: ' + urlPath);
  }
});
server.listen(8080, '0.0.0.0', () => log('Server ready on port 8080'));
