var express = require('express');
var router = express.Router();
const sql = require('mssql');



const config = {
  user: 'sa',       // e.g., 'sa' or a specific SQL user
  password: 'dudtjs0313',   // e.g., 'YourStrongPassword!'
  server: '127.0.0.1', // e.g., 'localhost', '192.168.1.100', 'YOUR_SERVER_NAME\SQLEXPRESS'
  database: 'SF_POP',  // e.g., 'master', 'Northwind'
  options: {
      encrypt: false, // Use true for Azure SQL Database or if you have an SSL certificate
      trustServerCertificate: true // Change to true for local dev / self-signed certs
  }
};

// Connect to MSSQL
async function connectToMssql() {
  try {
      await sql.connect(config);
      console.log('Connected to MSSQL');
  } catch (err) {
      console.error('Database connection failed:', err);
  }
}

// Call the connection function when the app starts
connectToMssql();

/* GET users listing. */
router.get('/', async function(req, res, next) {
  try {
    console.log('app.get');

      const result = await sql.query`SELECT TOP 10 * FROM bm_emp`; // Replace YourTableName with an actual table name
      
      res.json(result.recordset);
  } catch (err) {
      console.error('SQL error:', err);
      res.status(500).send('Error fetching data from database');
  }
});

module.exports = router;
