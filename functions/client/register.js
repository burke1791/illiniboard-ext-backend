
import { connection } from '../../utilities/db';
import mssql from 'mssql';

// registers a new extension by generating a guid in the database and returning it to the client
export async function handler(event, context, callback) {
  context.callbackWaitsForEmptyEventLoop = false;

  console.log(event);

  try {
    if (!connection.isConnected) {
      await connection.createConnection();
    }

    const request = new mssql.Request();

    let result = await request.execute('dbo.up_RegisterNewExtension');

    let response = {
      statusCode: 200,
      body: result.recordset
    };

    callback(null, JSON.stringify(response));
  } catch (error) {
    console.log(error);
    callback(null, error);
  }
}