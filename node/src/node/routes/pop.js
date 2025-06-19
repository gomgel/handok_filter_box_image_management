var express = require('express');
var dirver = require("mssql/msnodesqlv8");
var pool = require('../common/connectionpool');
var o2x = require('object-to-xml');
var router = express.Router();

/* api for checking rest api */
router.get('/check', async function(req, res, next) {

    var connection = await pool;

    const request = await connection.request()
    .query('SELECT GETDATE() now;', (err, result) => {

        console.log(result);

        res.set('Content-Type', 'text/xml');
        res.send(o2x({
           '?xml version="1.0" encoding="utf-8"?' : null,
             records: { record: result.recordset}
            }));
    } );   



});

/* get team info */
router.get('/team', async function(req, res, next) {

    var connection = await pool;

    const request = await connection.request()
    .input('p_action', dirver.NVarChar(50), '')
    .output('p_result_code', dirver.NVarChar(5))
    .output('p_result_msg', dirver.NVarChar(100))
    //.output('P_ERRO_TEXT', dirver.NVarChar)
    .execute('pr_get_db_team_info', (err, result) => {

        res.set('Content-Type', 'text/xml');
        res.send(o2x({
           '?xml version="1.0" encoding="utf-8"?' : null,
             records: { record: result.recordset}
            }));
    } );   

});

/* get config */
router.get('/config', async function(req, res, next) {

    var connection = await pool;

    

    const request = await connection.request()
    .input('p_action', dirver.NVarChar(50), '')
    .input('p_team_no', dirver.NVarChar(6), '')
    .output('p_result_code', dirver.NVarChar(5))
    .output('p_result_msg', dirver.NVarChar(100))
    //.output('P_ERRO_TEXT', dirver.NVarChar)
    .execute('pr_get_db_config', (err, result) => {

        res.set('Content-Type', 'text/xml');
        res.send(o2x({
           '?xml version="1.0" encoding="utf-8"?' : null,
             records: { record: result.recordset}
            }));
    } );   



});

/* get production */
//http://localhost:3000/pop/production?date=20240627
router.get('/production', async function(req, res, next) {

    console.log('[' + (new Date) + '] => ' +  'query string => ' + req.query.date);

    var connection = await pool;

    const request = await connection.request()
    .input('p_action', dirver.NVarChar(50), '')
    .input('p_work_dat', dirver.NVarChar(10), req.query.date)
    .output('p_result_code', dirver.NVarChar(5))
    .output('p_result_msg', dirver.NVarChar(100))
    //.output('P_ERRO_TEXT', dirver.NVarChar)
    .execute('pr_get_db_production', (err, result) => {
        res.set('Content-Type', 'text/xml');
        res.send(o2x({
           '?xml version="1.0" encoding="utf-8"?' : null,
             records: { record: result.recordset}
            }));
    } );   



});


/* GET users listing. */
// router.get('/config', async function(req, res, next) {

//     var connection = await pool;

//     const request = await connection.request()
//     .input('p_action', dirver.NVarChar(50), '')
//     .input('p_team_no', dirver.NVarChar(6), '')
//     .output('p_result_code', dirver.NVarChar(5))
//     .output('p_result_msg', dirver.NVarChar(100))
//     //.output('P_ERRO_TEXT', dirver.NVarChar)
//     .execute('pr_db_config', (err, result) => {
//         //const output = (request.output || {});
//         //console.log('request.output p_result_code : ' || result.parameters.p_result_code.value);

//         console.log(result.output.p_result_code);

//         let returnData = { return_code  : result.output.p_result_code, 
//                            return_msg   : result.output.p_result_msg, 
//                            record_set   : result.recordset };
//         res.writeHead('200', {'Content-Type': 'application/json; charset=utf8'});
//         res.write(JSON.stringify(returnData));
//         res.end();
//     } );   



// });



module.exports = router;