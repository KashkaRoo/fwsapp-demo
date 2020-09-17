var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require("cors");
var bodyParser = require('body-parser')
var fileUpload = require('express-fileupload');
var fs = require('fs');

//var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var herpRouter = require('./routes/herpRoute');
var xyRoute = require('./routes/xyRoute');
var organismRoute = require('./routes/organismRoute');
var crimRoute = require('./routes/crimRoute.js')

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(cors());
app.use(logger('dev'));
app.use(bodyParser.json({limit: '1000mb', extended: true}))
app.use(bodyParser.urlencoded({ limit: "1000mb", extended: true, parameterLimit: 50000 }))
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static('public'));

//app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/herpetology', herpRouter);
app.use('/xylarium', xyRoute);
app.use('/organism', organismRoute);
app.use('/criminalistics', crimRoute);


// catch 404 and forward to error handler
/*app.use(function(req, res, next) {
  next(createError(404));
});*/

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

// default options
app.use(fileUpload());

app.post('/upload/:database/:ID', function(req, res) {
  var dir = "./public/Docs/" + req.params.database + "/" + req.params.ID;
  if (!req.files || Object.keys(req.files).length === 0) {
    return res.status(200).send('No files were uploaded.');
  }

  //Check if dir exists with ID, if not, make on.
  if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
  }


  // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
  let attachment = req.files.attachment;
  console.log("attachment length: ", attachment.length);
  //console.log(attachment[0].name, " --------- ", attachment[1].name);
  // Use the mv() method to place the file somewhere on your server
  let i;
  if (attachment.length){
    for (i = 0; i < attachment.length; i++) {
      attachment[i].mv('./public/Docs/' + req.params.database + '/' + req.params.ID + '/' + attachment[i].name, function(err) {
        if (err)
          return res.status(500).send(err);

      }); 
    }
    res.send({
      status: true,
      message: 'File is uploaded',
    });
  }
  else {
    attachment.mv('./public/Docs/' + req.params.database + '/'  + req.params.ID + '/' + attachment.name, function(err) {
      if (err)
        return res.status(500).send(err);
      else {
        res.send({
          status: true,
          message: 'File is uploaded',
        });
      }
    }); 
  }

  
});

app.get('/getFiles/:database/:ID', function(req, res) {
  var dir = "./public/Docs/" + req.params.database + '/' + req.params.ID;
  fs.readdir(dir, function (err, files) {
    //handling error
    if (err) {
        console.log('Unable to scan directory: ', dir + err)
        files = [];
    } 
    console.log(files)
    res.send(files)
/*     //listing all files using forEach
    files.forEach(function (file) {
        // Do whatever you want to do with the file
        console.log(file); 
    }); */
  });
});


/* app.get('/download/:ID/:fileName', function(req, res){
  var file = "./public/Docs/" + req.params.database + '/'+ req.params.ID + "/" + req.params.fileName;
  res.render(file); // Set disposition and send it.
}); */

app.get('/deleteFile/:database/:ID/:fileName', function(req, res){
  var path = "./public/Docs/" + req.params.database + '/' + req.params.ID + "/" + req.params.fileName;
  try {
    fs.unlinkSync(path)
    //file removed
  } catch(err) {
    res.send({
      status: false,
      message: err,
  })
  }
    res.send({
      status: true,
      message: 'File is deleted',
  })
});

app.use(express.static(path.join(__dirname, '/fws-app/build')))

app.get('/*', function(req, res, next) {
  res.sendFile(path.join(__dirname + '/fws-app/build/index.html'))
});


module.exports = app;
