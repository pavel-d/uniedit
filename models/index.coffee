config = require '../config'

Sequelize = require 'sequelize'

sequelize = new Sequelize(config.database)


Document = sequelize.define 'Document',
  {
    text:
      type: Sequelize.TEXT,
      defaultValue: ''
  },
  {
    instanceMethods:
      insert: (pos, newString, transaction) ->
        text = @getDataValue('text')
        if (pos > 0)
          @setDataValue('text', text.substring(0, pos) + newString + text.substring(pos, text.length))
        else
          @setDataValue('text', newString + text)
        @save({ transaction: transaction })

      remove: (pos, length, transaction) ->
        text = @getDataValue('text')
        newText = text.slice(0, pos) + text.slice(pos + length, text.length)
        @setDataValue('text', newText)
        @save({ transaction: transaction })
  }

# Create DB structure
Document.sync()

module.exports.Document = Document
module.exports.sequelize = sequelize