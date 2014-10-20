Document = require('../models').Document

# new Document().save

module.exports.index = (req, res) ->
  doc = Document.create().then (doc) ->
    res.redirect '/' + doc.id

module.exports.show = (req, res) ->
  Document.find(where: {id: req.params.id}).then (doc) ->
    res.render 'doc', { doc: doc }