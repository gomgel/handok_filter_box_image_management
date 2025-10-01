var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var dirver = require("mssql/msnodesqlv8");

var pool = require('./common/connectionpool');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var popRouter = require('./routes/pop');
var pdaRouter = require('./routes/pda');
//20250619-01
var app = express();

const os = require('os');
os.hostname = () => 'localhost';

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/images', express.static('images'));
app.use('/setup', express.static('setup'));

var lastExectime = new Date();


// ( async function() {

//   console.log('in async function...');

//   var connection = await pool;

//   const result = await connection.request()
//   .input('P_COWK_CODE', dirver.VarChar(8), 'COWK0001')//이건 urlpram에 변수명이 들어가는데 전체코드를 봤을때 이해함
//   .output('P_SUCC_CODE', dirver.Int)
//   .output('P_RETR_TEXT', dirver.VarChar(500))
//   .output('P_ERRO_TEXT', dirver.VarChar(500))
//   .execute('SP_OQPRDTPM_SEL_01_TEST');   

//   console.log(result);

// })();

// (async () => {
//   try {
//       console.log("start config2");
//       await sql.connect(config2);  // both format of dbConfig or dbConfig2 will work
//       const result = await sql.query(`select SYSDATETIME() as dt `);
//       console.dir(result.recordset);
//       console.log("end config2");
//   } catch (err) {
//       // 
//       console.log(err);
//   } finally {
//       //
//   }
// })();




app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/pop', popRouter);
app.use('/pda', pdaRouter);

const intervalObj = setInterval(async () => {
  console.log('intervaiewing the interval : ' + lastExectime);



  if ( ( Math.floor(( (new Date) - lastExectime)/1000/60) ) < 1 ) {     
  } else {
    var connection = await pool;

    const request = await connection.request()
    .input('p_action', dirver.NVarChar(50), 'time')
    .output('p_result_value', dirver.NVarChar(14))
    .output('p_result_code', dirver.NVarChar(5))
    .output('p_result_msg', dirver.NVarChar(100))
    .execute('pda_get_now', (err, result) => {
  
      console.log(result.output.p_result_value);
      
      if (err) {
        console.log('getServerTime: '  + err);
        return 0;                 
      } else {      
        return 1;
      }
    } );  
  }

}, 10000);

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
