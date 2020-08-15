import { invokeLambda } from '../../utilities/helper';
import { ENDPOINTS } from '../../utilities/constants';

/**
 * The API Gateway root function for implementing routing logic
 * @function root
 */
export async function main(event) {
  console.log(event);

  let path = event.path;
  let method = event.httpMethod;

  let functionName = ENDPOINTS[method][path];

  var params = constructLambdaInvokeParams(method, event, functionName);
  console.log(params);

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

function constructLambdaInvokeParams(method, event, functionName) {
  var params = {
    FunctionName: functionName,
    InvocationType: 'RequestResponse',
    LogType: 'Tail'
  };

  switch (method) {
    case 'GET':
      params.Payload = JSON.stringify(event.queryStringParameters);
      break;
    case 'POST':
      params.Payload = JSON.stringify(event.body);
      break;
    default:
      console.log('default switch firing');
      params.Payload = JSON.stringify(event.body);
  }

  return params;
}