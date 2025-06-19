
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

const os = require('os');
os.hostname = () => 'localhost';

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);


console.log(path.join(__dirname, 'myfile.txt'));

const timeStamp = (new Date()).toISOString().replace(/[^0-9]/g, '').slice(0, -3)

console.log(timeStamp)
//2025-06-17-08:44:27




// app.get('/users', async (req, res) => {
//   try {
//     console.log('app.get');

//       const result = await sql.query`SELECT TOP 10 * FROM bm_emp`; // Replace YourTableName with an actual table name
      
//       //res.json(result.recordset);
//   } catch (err) {
//       console.error('SQL error:', err);
//       res.status(500).send('Error fetching data from database');
//   }
// });



// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
