Document = require('../models').Document

# new Document().save

module.exports.index = (req, res) ->
  doc = new Document()
  doc.save (err) ->
    res.redirect '/' + doc._id

module.exports.show = (req, res) ->
  Document.findById req.params.id, (err, doc) ->
    res.render 'doc', { doc: doc }