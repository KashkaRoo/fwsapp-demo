var express = require('express');
var router = express.Router();

/* GET home page. */
/* GET home page. */
router.get('/', function(req, res, next) {
  res.sendFile(path.join(__dirname + '/fws-app/build/index.html'))
});

module.exports = router;
