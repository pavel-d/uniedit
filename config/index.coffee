development =
  database: 'mongodb://localhost/aneditor'

production =
  database: process.env.MONGOHQ_URL

module.exports = if process.env.NODE_ENV == 'production' then production else development