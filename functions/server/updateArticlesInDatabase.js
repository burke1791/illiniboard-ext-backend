
import mssql from 'mssql';
import { connection } from '../../utilities/db';

export async function handler(event, context, callback) {
  context.callbackWaitsForEmptyEventLoop = false;

  try {
    await connection.createConnection();

    const tvp = new mssql.Table();

    tvp.columns.add('Title', mssql.NVarChar(512));
    tvp.columns.add('Url', mssql.NVarChar(1024));
    tvp.columns.add('Description', mssql.NVarChar(2000));
    tvp.columns.add('PublishDate', mssql.NVarChar(250));

    for (var article of event) {
      let pubDate = new Date(article.pubDate).toISOString();

      tvp.rows.add(
        article.title,
        article.link,
        article.description,
        pubDate
      );
    }

    const request = new mssql.Request();

    request.input('Articles', tvp);

    let results = await request.execute('dbo.up_UpdateArticlesFromRSS');

    callback(null, results.recordset);
  } catch (error) {
    console.log(error);
  }
}