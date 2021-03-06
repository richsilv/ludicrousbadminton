var fs = require('fs');
var express = require('express');

var app = express.createServer(express.static(__dirname + '/LudicrousBadminton'));

app.get('/', function(request, response) {
  response.send(fs.readFileSync('LudicrousBadminton.html').toString());
});

var port = process.env.PORT || 8080;
app.listen(port, function() {
  console.log("Listening on " + port);
});
