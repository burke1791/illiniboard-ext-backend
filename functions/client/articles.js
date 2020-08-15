import mssql from 'mssql';
import { connection } from '../../utilities/db';

/**
 * @function checkNewArticles
 * @param extensionGuid {string} - the user's extension guid
 * Checks the database for any new articles the user hasn't read
 */
export async function checkNewArticles(payload) {
  console.log(payload);

  let extensionGuid = payload.extensionGuid;
  let prevArticleId = payload.prevArticleId ? payload.prevArticleId : null;

  try {
    if (!connection.isConnected) {
      await connection.createConnection();
    }

    const request = new mssql.Request();
    request.input('ExtensionGuid', mssql.VarChar(256), extensionGuid);
    request.input('PrevArticleId', mssql.BigInt, prevArticleId);

    let result = await request.execute('dbo.up_GetRecentUnreadArticles');

    console.log(result);

    return result.recordset;
  } catch (error) {
    console.log(error);
    return error;
  }
}