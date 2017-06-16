const express = require('express')
const path = require('path')
const app = express()

// Serve up the UI from the build dir
app.use('/', express.static(path.join(__dirname, 'build')))

// Respond with a personalised message when a GET request is made to the homepage
/*app.get('/:name', function (req, res) {
  res.send(`Hello ${req.params.name}, this is your Nugget`)
})*/

// Start a server on port 80 and log its start to our console
let server = app.listen(8080, function () {
  let port = server.address().port;
  console.log(`Example app listening on port ${port}`);
});
