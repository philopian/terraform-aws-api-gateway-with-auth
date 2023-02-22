const logger = require("./utils/logger.js");

const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE",
  "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
};

module.exports.handler = async (event) => {
  let statusCode = 200;
  let body = {};
  let response = {};

  switch (event.httpMethod) {
    case "GET":
      logger("[GET]");
      body = {
        type: "you requested a GET!!!",
      };
      response = {
        statusCode,
        headers,
        body: JSON.stringify(body),
      };
      return response;

    case "POST":
      body = {
        type: "you requested a POST!!!",
        queryStringParameters: event.queryStringParameters,
        body: event.body,
      };
      response = {
        statusCode,
        headers,
        body: JSON.stringify(body),
      };
      return response;
    default:
      statusCode = 200;
      body = {
        type: "OTHER!",
      };
      response = {
        statusCode,
        headers,
        body: JSON.stringify(body),
      };
      return response;
  }
};
