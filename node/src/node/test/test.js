//note: please make double ( \\ ) before your instance name
//if you get confused then please watch the video link at the bottom you can see in details about this

// now make the connections as 

//create a database configuration 

// var config = {
//   server : "127.0.0.1", // eg:: 'DESKTOP_mjsi\\MSSQLEXPRESS'
//   database: "OQ",
//   user :"sa",      // please read above note
//   password:"asd123!@#",   // please read above note
//   options : {
//   trustedConnection:true, 
//   },
//   driver:"msnodesqlv8",
// }


// sql.connect(config, function(err){
//   if(err) { 
//     console.log(err);
//   } 
//   else {
//     console.log('success...');

//     // make a request as
  
//     var request = new sql.Request();
  
//    //make the query

  
//     queryString = "SELECT * FROM INFORMATION_SCHEMA.TABLES";  // eg : "select * from tbl_name"
  
//     console.log('query')

//     request.query(queryString, function(err, recordset){
//       if (err) {
//         console.log(err);
//       } else {
//         console.log(recordset);
//       }
      
//     });


//     console.log('start sp...');

//      // 저장프로시저 사용법
//      new sql.Request()
//        .input('P_COWK_CODE', sql.VarChar(8), 'COWK0001')//이건 urlpram에 변수명이 들어가는데 전체코드를 봤을때 이해함
//        .output('P_SUCC_CODE', sql.Int)
//        .output('P_RETR_TEXT', sql.VarChar(500))
//        .output('P_ERRO_TEXT', sql.VarChar(500))
//        .execute('SP_OQPRDTPM_SEL_01_TEST', (err, result) => {
//            // ... error checks
//            if(err){
//               console.log(err);		//에러가났을때 에러메세지 리턴
//            }else{
//               console.log(result.recordset);		//보면 이게 result에 값이 여러개 저장되어있는데 recordset으로 리턴한거임
//            }
//        });    


//   }

// });