development =
  database: 'mysql://root@localhost/uniedit'

production =
  database: process.env.DATABASE_URL

module.exports = if process.env.NODE_ENV == 'production' then production else development