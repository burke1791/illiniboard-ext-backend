import AWS from 'aws-sdk';
import https from 'https';
import { DOMParser } from 'xmldom';

AWS.config.region = 'us-east-1';
var lambda = new AWS.Lambda();

export function invokeLambda(params) {
  return lambda.invoke(params).promise();
}

export function httpRequest(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
  
      const parser = new DOMParser();
      let xmlString = '';
  
      res.on('data', (d) => {
        xmlString += d;
      });

      res.on('end', () => {
        let xmlDoc = parser.parseFromString(xmlString, 'text/xml');
        resolve(xmlDoc);
      });
  
    }).on('error', (e) => {
      reject(e);
    });
  });
}