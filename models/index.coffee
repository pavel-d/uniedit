config = require '../config'

mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/test'

# Document Schema
documentSchema = mongoose.Schema
  text: String
  version: Number
  created_at: Date
  updated_at: Date

documentSchema.pre 'save', (next) ->
  @set('created_at', new Date) if @isNew
  @set('updated_at', new Date)
  next()

# Instance Methods
documentSchema.methods.insert = (pos, newString, cb) ->
  if (pos > 0)
    @text = @text.substring(0, pos) + newString + @text.substring(pos, @text.length)
  else
    @text = newString + @text
  @save(cb)

documentSchema.methods.remove = (pos, length, cb) ->
  @text.slice(0, pos) + @text.slice(pos + length, @text.length)
  @save(cb)

# Model
Document = mongoose.model 'Document', documentSchema


module.exports.Document = Document