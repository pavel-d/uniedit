Document = require('../models').Document
sequelize = require('../models').sequelize

module.exports = (server) ->
  io = require('socket.io')(server)

  io.on 'connect', (socket) ->

    socket.on 'documentRequest', (data) ->
      documentId = data.id
      socket.join(documentId);
      Document.find(where: { id: documentId }).then (doc) ->
        socket.emit 'documentFullUpdate', { text: doc.text }

    socket.on 'documentChanged', (data) ->
      action = data.action
      documentId = data.id

      switch action
        when 'insert'
          sequelize.transaction (t) ->

            Document.find(where: {id: documentId }, { transaction: t, lock: t.LOCK.UPDATE }).then (doc) ->
              doc.insert(data.pos, data.text, t).then (doc) ->
                socket.broadcast.to(documentId).emit 'documentUpdate', { action: 'insert', range: data.range, text: data.text }

        when 'remove'
          sequelize.transaction (t) ->

            Document.find(where: {id: documentId }, { transaction: t, lock: t.LOCK.UPDATE }).then (doc) ->
              doc.remove(data.pos, data.length, t).then (doc) ->
                socket.broadcast.to(documentId).emit 'documentUpdate', { action: 'remove', range: data.range }
