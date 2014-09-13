$ ->

  socket = io.connect 'http://localhost:3000/';
  aceDocument = AnEditor.getSession().getDocument()

  supress = false

  aceDocument.on 'change', (e) ->
    updateRemoteDocument(e.data) unless supress

  socket.on 'documentUpdate', (data) =>
    supress = true
    updateLocalDocument(data)
    supress = false


  updateLocalDocument = (data) ->
    action = data.action
    switch action
      when 'insert'
        aceDocument.insert(data.pos, data.text)
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
      socket.emit('documentChanged', { action: 'insert', range: range, text: text })
    remove: (range, length) ->
      socket.emit('documentChanged', { action: 'remove', range: range, length: length })
