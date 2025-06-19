
module.exports = {
    server : "127.0.0.1", // eg:: 'DESKTOP_mjsi\\MSSQLEXPRESS'
    database: "SF_POP",
    port : 1433,
    user :"sa",      // please read above note
    password:"dudtjs0313",   // please read above note
    options : {
        trustedConnection:true, 
        encrypt: false, // Use true for Azure SQL Database or if you have an SSL certificate
    },
    driver:"msnodesqlv8",
    pool : {max:5, min:1, idleTimeoutMillis:30000,},
    trustServerCertificate: true

}

// module.exports = {
//     server : "127.0.0.1",//"SIWOO\\SQLEXPRESS", // eg:: 'DESKTOP_mjsi\\MSSQLEXPRESS'
//     port:1433,
//     database: 'OQ',
//     user :'sa',      // please read above note
//     password:"asd123!@#",   // please read above note    
//     driver:"msnodesqlv8",
//     options : {
//         trustedConnection:true, 
//         enableArithAbort: true
//     },
//     pool : {max:5, min:1, idleTimeoutMillis:30000,},

// }



// module.exports = {
//     server : "localhost", // eg:: 'DESKTOP_mjsi\\MSSQLEXPRESS'
//     database: "OQ",
//     user :"sa",      // please read above note
//     password:"asd123!@#",   // please read above note
//     options : {
//         trustedConnection:true, 
//     },
//     driver:"msnodesqlv8",
//     pool : {max:5, min:1, idleTimeoutMillis:30000,},
//     trustServerCertificate: true

// }
