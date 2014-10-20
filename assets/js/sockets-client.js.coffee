$ ->

  documentId = $('#editor').data('document-id')

  socket = io.connect '/'

  aceDocument = AnEditor.getSession().getDocument()

  supress = false

  aceDocument.on 'change', (e) ->
    updateRemoteDocument(e.data) unless supress

  socket.on 'connect', ->
    socket.emit('documentRequest', id: documentId)

  socket.on 'documentUpdate', (data) ->
    supress = true
    updateLocalDocument(data)
    supress = false

  socket.on 'documentFullUpdate', (data) ->
    supress = true
    aceDocument.setValue(data.text)
    supress = false


  updateLocalDocument = (data) ->
    action = data.action
    switch action
      when 'insert'
        aceDocument.insert(data.range.start, data.text)
      when 'remove'
        aceDocument.remove(data.range)


  updateRemoteDocument = (changes) ->
    action = changes.action

    switch action
      when "insertText"
        remoteDoc.insert changes.range, changes.text
      when "removeText"
        remoteDoc.remove changes.range, changes.text.length
      when "insertLines"
        text = changes.lines.join("\n") + "\n"
        remoteDoc.insert changes.range, text
      when "removeLines"
        text = changes.lines.join("\n") + "\n"
        remoteDoc.remove changes.range, text.length
      else
        throw new Error("unknown action: " + changes.action)


  remoteDoc =
    insert: (range, text) ->
      socket.emit('documentChanged', { id: documentId, action: 'insert', range: range, pos: rangeToPos(range), text: text })
    remove: (range, length) ->
      socket.emit('documentChanged', { id: documentId, action: 'remove', range: range, pos: rangeToPos(range), length: length })

  rangeToPos = (range) ->
    lines = aceDocument.getLines 0,  range.start.row
    pos = 0

    for line, index in lines
      pos += if (index < range.start.row) then line.length else range.start.column

    pos + range.start.row