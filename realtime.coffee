Document = require './models/document'

module.exports = (server) ->
  io = require('socket.io')(server)
  
  document = new Document()

  io.on 'connection', (socket) -> 
    socket.on 'documentChanged', (data) ->
      action = data.action
      console.log data
      switch action
        when 'insert'
          socket.broadcast.emit 'documentUpdate', { action: 'insert', pos: data.range.start, text: data.text }
        when 'remove'
          socket.broadcast.emit 'documentUpdate', { action: 'remove', range: data.range }


