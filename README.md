# Roda | SSE Demo 

This is a demo of using [Server Sent Events (SSE)](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events) with Roda and HTMX.


1. message submitted to POST /message endpoing
2. message saved to db
3. stream loop checks db in loop and picks up message
4. message is then streamed back to the client



## Setup

1. Seed the db

```
bundle exec ruby db/setup.rb
```

2. Run the server

```
bundle exec falcon serve
```


3. Open the app in multiple windows

```
https://localhost:9292/
```