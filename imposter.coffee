#!/usr/bin/env coffee

path = require('path')
pkg = require(path.join(__dirname, "./package.json"))
request = require('request')
app = require('http').createServer(handler)
io = require('socket.io').listen(app)
io.set('log level', 1)
io.set('transports', ['websocket'])

handler = (req, res) ->
  res.writeHead(200)
  res.end()

io.sockets.on 'connection', (socket) ->
  socket.on 'get', (req, callback) ->
    request.get req.url, (err, res, body) ->
      callback err,
        text: body
        statusCode: res.statusCode
        headers: res.headers

app.listen process.env['PORT'] or 9000
