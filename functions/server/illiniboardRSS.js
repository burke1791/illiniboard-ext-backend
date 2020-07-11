
import { IB_RSS_URL } from '../../utilities/constants';
import { invokeLambda, httpRequest } from '../../utilities/helper';
import { parseIlliniboardRss } from '../../utilities/illiniboard';

export async function handler(event, context, callback) {
  let response = await updateArticlesInDatabase();

  callback(null, response);
}

async function updateArticlesInDatabase() {
  try {
    let responseXml = await httpRequest(IB_RSS_URL);
    let articles = parseIlliniboardRss(responseXml);

    // invoke lambda that updates the articles table in the database
    var params = {
      FunctionName: 'UpdateIBArticlesInDatabase',
      InvocationType: 'RequestResponse',
      LogType: 'Tail',
      Payload: JSON.stringify(articles)
    };
  
    let response = await invokeLambda(params);

    return response;
  } catch (error) {
    console.log(error);
  }
}