express = require 'express'
router = express.Router()
controllers = require '../controllers'

router.get '/', controllers.main.index
router.get '/:id', controllers.main.show

module.exports = router