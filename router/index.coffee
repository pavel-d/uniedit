express = require 'express'
router = express.Router()
controllers = require '../controllers'

router.get '/', controllers.main.index

module.exports = router