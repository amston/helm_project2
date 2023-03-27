const http = require('http')
const express = require('express')
const app = express()
require('dotenv').config()
const PORT = process.env.PORT || 3000
var cache = require('memory-cache')
const { v4:uuidv4 } = require('uuid')
const randomString = uuidv4()
cache.put('randomString', randomString)

app.get('/', (request, response) => {
  const date = new Date()
  const date_now = date.toISOString()
  const random_string = cache.get('randomString')
  response.send(`${date_now}: ${random_string}`)
})

app.listen(PORT, () => {
  const start_string = cache.get('randomString')
  console.log(`Started with ${start_string}`)
})
