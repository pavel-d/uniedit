class Document
  constructor: ->
    @text = ''

  insert: (pos, text) ->
    @text = insert(pos, text, @text)

  remove: (pos, length) ->
    @text = remove(pos, length, @text)

insert = (index, another, string) ->
  if (index > 0)
    return string.substring(0, index) + another + string.substring(index, string.length);
  else
    return another + string;

remove = (pos, length, string) ->
  string.slice(0, pos) + string.slice(pos + length, string.length)

module.exports = Document