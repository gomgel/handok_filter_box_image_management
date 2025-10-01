var express = require('express');
var router = express.Router();
var pool = require('../common/connectionpool');
var dirver = require("mssql/msnodesqlv8");
var o2x = require('object-to-xml');
var multer = require('multer');
var path = require('path');
var env = require('../common/setting');

function dateFormat(now) {
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0'); // Month is 0-indexed
  const day = String(now.getDate()).padStart(2, '0');
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');

  return `${year}${month}${day}${hours}${minutes}${seconds}`;
}

router.get('/', function(req, res, next) {
  res.send('this page is about a pda');
});



console.log( env.version + ' - ' + dateFormat(new Date()).substring(0, 8) );


/* get employees */
//http://localhost:3000/pda/emp?name_1st=ㄱ&name_2nd=ㅎ&name_3rd=ㅅ
router.get('/emp', async function(req, res, next) {

  console.log('[' + (new Date) + '] => ' +  'query string => ' + req.query.name_1st + ' - ' + req.query.name_2nd + ' - ' + req.query.name_3rd);

  var connection = await pool;

  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), '')
  .input('p_emp_nm_1st', dirver.NVarChar(10), req.query.name_1st)
  .input('p_emp_nm_2nd', dirver.NVarChar(10), req.query.name_2nd)
  .input('p_emp_nm_3rd', dirver.NVarChar(10), req.query.name_3rd)
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(100))
  //.output('P_ERRO_TEXT', dirver.NVarChar)
  .execute('pda_get_emp', (err, result) => {

      if (err) {
        console.log('error found : '  + err);

        let returnData = { 
          return_code : '-1', 
          return_msg : err.originalError.info.message, 
          return_data : []}      
        

          res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});
          res.write(JSON.stringify(returnData));		
          res.end();	          
      } else {

      
        console.log(result.output.p_result_code);
        console.log(result.output.p_result_msg);

        let returnData = { 
          return_code : result.output.p_result_code, 
          return_msg : result.output.p_result_msg, 
          return_data : result.recordset }

        //console.log(result.recordset);

        res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});

        res.write(JSON.stringify(returnData));
        
        res.end();	
      }
  } );  
});


/* get lines */
//http://localhost:3000/pda/line?name_1st=ㅅ&name_2nd=&name_3rd=
router.get('/line', async function(req, res, next) {

  console.log('[' + (new Date) + '] => ' +  'query string => ' + req.query.name_1st + ' - ' + req.query.name_2nd + ' - ' + req.query.name_3rd);

  var connection = await pool;

  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), '')
  .input('p_line_nm_1st', dirver.NVarChar(10), req.query.name_1st)
  .input('p_line_nm_2nd', dirver.NVarChar(10), req.query.name_2nd)
  .input('p_line_nm_3rd', dirver.NVarChar(10), req.query.name_3rd)
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(100))
  //.output('P_ERRO_TEXT', dirver.NVarChar)
  .execute('[pda_get_line]', (err, result) => {

      if (err) {
        console.log('error found : '  + err);

        let returnData = { 
          return_code : '-1', 
          return_msg : err.originalError.info.message, 
          return_data : []}      
        

          res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});
          res.write(JSON.stringify(returnData));		
          res.end();	          
      } else {

      
      console.log(result.output.p_result_code);
      console.log(result.output.p_result_msg);

      let returnData = { 
        return_code : result.output.p_result_code, 
        return_msg : result.output.p_result_msg, 
        return_data : result.recordset }

      //console.log(result.recordset);

		  res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});

		  res.write(JSON.stringify(returnData));
		  
		  res.end();	
    }
  } );  

});

/* get Production Count infomation */
//http://localhost:3000/pda/info/count?from=20250807&to=20250807&line=A1000
router.get('/info/count', async function(req, res, next) {

  console.log('[' + (new Date) + '] => ' +  'query string => ' + req.query.from + ' - ' + req.query.to + ' - ' + req.query.line);

  var connection = await pool;

  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), 'count_01')
  .input('p_from_date', dirver.NVarChar(8), req.query.from)
  .input('p_to_date', dirver.NVarChar(8), req.query.to)
  .input('p_line_no', dirver.NVarChar(10), req.query.line)
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(100))
  .execute('[pda_get_screenshot]', (err, result) => {

      if (err) {
        console.log('error found : '  + err);

        let returnData = { 
          return_code : '-1', 
          return_msg : err.originalError.info.message, 
          return_data : []}      
        

          res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});
          res.write(JSON.stringify(returnData));		
          res.end();	          
      } else {

        let returnCount = 0;

        if ( result.recordset.length == 0 ) {
          returnCount = 0;
        } else {
          returnCount = result.recordset[0].count;
        }

        console.log(result);

        let returnData = { 
          return_code : result.output.p_result_code, 
          return_msg : result.output.p_result_msg, 
          return_data : returnCount }

        //console.log(result.recordset);

        res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});

        res.write(JSON.stringify(returnData));
        
        res.end();	
      }
  } );  

});

/* get version */
//http://localhost:3000/pda/version
router.get('/version', async function(req, res, next) {
  let returnData = { 
    return_code : '1', 
    return_msg : 'success',         
    return_data : { 'version' : env.version, 'number' : env.number} }

  //console.log(result.recordset);

  res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});
  res.write(JSON.stringify(returnData));  
  res.end();	 
});

async function saveScreenshotInfo (
  uuid,
  date,
  line,
  file_name,
  file_path,
  emp1,
  emp2,
  emp3
  ) {
  var connection = await pool;

  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), 'insert')
  .input('p_image_uuid', dirver.NVarChar(30), uuid)
  .input('p_image_date', dirver.NVarChar(8), date)
  .input('p_line_no', dirver.NVarChar(10), line)
  .input('p_file_name', dirver.NVarChar(30), file_name)
  .input('p_file_path', dirver.NVarChar(100), file_path)
  .input('p_emp1', dirver.NVarChar(20), emp1)
  .input('p_emp2', dirver.NVarChar(20), emp2)
  .input('p_emp3', dirver.NVarChar(20), emp3)
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(100))
  .execute('pda_set_screenshot', (err, result) => {

    console.log(result.output.p_result_code);
    console.log(result.output.p_result_msg);

    if (err) {
      console.log('saveScreenshotInfo: '  + err);
      return 0;                 
    } else {      
      return 1;
    }
  } );  
}

async function getServerTime () {
  var connection = await pool;

  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), 'time')
  .output('p_result_value', dirver.NVarChar(5))
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(100))
  .execute('pda_set_now', (err, result) => {

    console.log(result.output.p_result_value);
    console.log(result.output.p_result_msg);

    if (err) {
      console.log('getServerTime: '  + err);
      return 0;                 
    } else {      
      return 1;
    }
  } );  
}

// Configure multer for file storage
const storage = multer.diskStorage({
	destination: (req, file, cb) => {
    console.log(' /upload post body => ' 	
    +  '[' + req.body.emp_0001  + ']' + ' , ' 
    +  '[' + req.body.emp_0002  + ']' + ' , ' 
    +  '[' + req.body.emp_0003  + ']' + ' , ' 
    +  '[' + req.body.line_code + ']' + ' , ' 
    +  '[' + req.body.line_name + ']' );	

    cb(null, 'images/'); // Specify the directory to save uploads
	},
	filename: (req, file, cb) => {
    //(new Date()).toISOString().replace(/[^0-9]/g, '').slice(0, -9)
	  const uniqueSuffix = dateFormat(new Date()) + '-' + Math.round(Math.random() * 1E8) + '-' + req.body.line_name;
	  const fileExtension = path.extname(file.originalname);
	  cb(null, 'image-' + uniqueSuffix + fileExtension);
	},
  });

const upload = multer({ storage: storage });  

  // Handle the POST request for uploading the screenshot
  router.post('/upload', upload.single('screenshot'), async function(req, res) {

	if (!req.file) {
	  return res.status(400).send('No file uploaded.');
	}
  
	// req.file contains information about the uploaded file
	console.log('Uploaded file:', req.file);
  
	// You can now process the file, save its path to a database, etc.
	const imageUrl = `/images/${req.file.filename}`; // Construct the URL to access the image
  

  var connection = await pool;
  const request = await connection.request()
  .input('p_action', dirver.NVarChar(50), 'insert')
  .input('p_image_uuid', dirver.NVarChar(30), req.file.filename.substring(6, 29))
  .input('p_image_date', dirver.NVarChar(8), dateFormat(new Date()).substring(0,8) )
  .input('p_line_no', dirver.NVarChar(10), req.body.line_code)
  .input('p_file_name', dirver.NVarChar(100), req.file.filename)
  .input('p_file_path', dirver.NVarChar(500), path.join(__dirname, '..', '\\images\\') + req.file.filename)
  .input('p_emp1', dirver.NVarChar(20), req.body.emp_0001)
  .input('p_emp2', dirver.NVarChar(20), req.body.emp_0002)
  .input('p_emp3', dirver.NVarChar(20), req.body.emp_0003)
  .output('p_result_code', dirver.NVarChar(5))
  .output('p_result_msg', dirver.NVarChar(300))
  .execute('pda_set_screenshot', (err, result) => {

    //console.log(result.output.p_result_code);
    //console.log(result.output.p_result_msg);

    if (err) {
      console.log('err: '  + err);
      res.status(200).json({ 
        message: 'Inserting into db is failed!', 
        imageUrl: imageUrl,
        resultCode: result.output.p_result_code, 
        resultMessage: result.output.p_result_msg 
      });                 
    } else {      
      if (result.output.p_result_code == '1') {
        res.status(200).json({ 
        message: 'Screenshot uploaded successfully!', 
        imageUrl: imageUrl,
        resultCode: result.output.p_result_code, 
        resultMessage: result.output.p_result_msg 
        });  
      } else {
        res.status(598).json({ 
          message: 'Inserting into db is Failed!', 
          imageUrl: imageUrl,
          resultCode: result.output.p_result_code, 
          resultMessage: result.output.p_result_msg 
          }); 
      } 
      //res.status(200).json({ message: 'Screenshot uploaded successfully!', imageUrl: imageUrl });
    }
  } );  

	
});

module.exports = router;
