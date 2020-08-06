import { invokeLambda } from '../../utilities/helper';
import { ENDPOINTS } from '../../utilities/constants';

/**
 * The API Gateway root function for implementing routing logic
 * @function root
 */
export async function main(event) {
  console.log(event);

  let path = event.path;
  let body = event.body;
  let method = event.httpMethod;

  let functionName = ENDPOINTS[method][path];

  var params = {
    FunctionName: functionName,
    InvocationType: 'RequestResponse',
    LogType: 'Tail',
    Payload: JSON.stringify(body)
  };

  try {
    let data = await invokeLambda(params);

    console.log(data);

    let response = {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data.Payload)
    }

    return response;
  } catch (error) {
    console.log(error);
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json'
      },
      body: 'test error, you fool'
    }
  }
}