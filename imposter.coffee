#!/usr/bin/env coffee

path = require('path')
pkg = require(path.join(__dirname, "./package.json"))
request = require('request')
WebSocketServer = require('ws').Server
wss = new WebSocketServer port: process.env['PORT'] or 9000
filter = require('./filter')

KEEP_ALIVE = 1000 * Number(process.env['KEEP_ALIVE'] or '30')

wss.on 'connection', (socket) ->
  socket.on 'message', (req) ->
    try
      req = JSON.parse(req)
      if req.verb
        request[req.verb] req.url, (err, res, body) ->
          if err
            req.error = err
          else
            req.text = body
            req.statusCode = res.statusCode
            req.responseHeaders = res.headers
          if process.env['DEBUG']
            console.log req
          socket.send filter(JSON.stringify(req)), (err) ->
            console.log err if err
      #keep alive ping
      if req.ping
        socket.send filter(JSON.stringify(pong: true)), (err) ->
          console.log err if err
    catch error
      console.log error

wss.on 'error', (error) ->
  console.log error

console.log 'listening on', process.env['PORT'] or 9000
