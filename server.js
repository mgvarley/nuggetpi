const express = require('express')
const app = express()

// Respond with a message when a GET request is made to the homepage
app.get('/', function (req, res) {
  res.send('Hello , this is your Nugget')
})

// Respond with a personalised message when a GET request is made to the homepage
app.get('/:name', function (req, res) {
  res.send(`Hello ${req.params.name}, this is your Nugget`)
})

// Start a server on port 80 and log its start to our console
let server = app.listen(80, function () {
  let port = server.address().port;
  console.log(`Example app listening on port ${port}`);
});
