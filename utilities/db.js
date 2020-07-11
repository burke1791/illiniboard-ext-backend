
const sql = require('mssql');

const config = {
  user: process.env.user,
  password: process.env.password,
  server: process.env.host,
  database: process.env.database
}

const connection = {
  isConnected: false,
  pool: null,
  createConnection: async function() {
    if (this.pool == null) {
      try {
        this.pool = await sql.connect(config);
        this.isConnected = true;
      } catch (error) {
        this.isConnected = false;
        this.pool = null;
      }
    }
  }
};

export {
  connection
};