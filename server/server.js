const path = require('path');
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
const bodyParser = require('body-parser')
app.use(express.static(path.join(__dirname, 'build')));

app.get('/ping', function (req, res) {
    return res.send('pong');
});

app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.listen(port, () => {
   console.log("Server is up on port %s.",port);
});
// app.listen(process.env.PORT || 8080);
