import mssql from 'mssql';
import { connection } from '../../utilities/db';

// registers a new extension by generating a guid in the database and returning it to the client
export async function register(payload) {
  console.log(payload);

  try {
    if (!connection.isConnected) {
      await connection.createConnection();
    }

    const request = new mssql.Request();

    let result = await request.execute('dbo.up_RegisterNewExtension');

    return result.recordset[0];
  } catch (error) {
    console.log(error);
    return error;
  }
}