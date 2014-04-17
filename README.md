# Overview

This is a very simple service that will relay HTTP over WebSockets. The
basic idea -- and it works -- is that you cut down the HTTP connection
and DNS time for REST APIs by tunneling them through a WebSocket.

So -- it's magical speed sauce to turn your REST API to 11.

# Usage

You run this as a server, just grab and and feed it an `npm start`. It
works best when you put it LAN-local to your REST services, on the same
host is the best of all.

Then, you connect to it with a `WebSocket`, and `send` along messages
that encapsualte a call to [request](https://github.com/mikeal/request).

```
var s = new WebSocket('ws://yourserver')
s.send({
verb: 'GET',
url: 'http://yourserver/restapi'
});

//...
//emits messages that add on .text, .statusCode, and .responseHeaders
```

You can pass along any other properties on the sent messages and they
will simply be echoed back, this is really handy way to have completion
tokens to look up for promises or message callbacks.

