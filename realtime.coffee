Document = require('./models').Document

module.exports = (server) ->
  io = require('socket.io')(server)
  
  io.on 'connect', (socket) ->
    
    socket.on 'documentRequest', (data) ->
      documentId = data.id
      Document.findById documentId, (err, doc) ->
        socket.emit 'documentFullUpdate', { text: doc.text }

    socket.on 'documentChanged', (data) ->
      action = data.action
      documentId = data.id

      switch action
        when 'insert'
          Document.findById documentId, (err, doc) ->
            console.log data.text
            doc.insert data.pos, data.text, ->
              socket.broadcast.emit 'documentUpdate', { action: 'insert', range: data.range, text: data.text }
        when 'remove'
          Document.findById documentId, (err, doc) ->
            doc.remove data.pos, data.length, ->
              socket.broadcast.emit 'documentUpdate', { action: 'remove', range: data.range }
