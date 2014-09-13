Document = require './models/document'

module.exports = (server) ->
  io = require('socket.io')(server)
  
  document = new Document()

  io.on 'connection', (socket) -> 
    socket.emit 'documentFullUpdate', { text: document.text }
    socket.on 'documentChanged', (data) ->
      action = data.action

      switch action
        when 'insert'
          document.insert(data.pos, data.text)
          socket.broadcast.emit 'documentUpdate', { action: 'insert', range: data.range, text: data.text }
        when 'remove'
          document.remove(data.pos, data.length)
          socket.broadcast.emit 'documentUpdate', { action: 'remove', range: data.range }
