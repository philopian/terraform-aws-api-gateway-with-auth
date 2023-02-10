const logger = require("./utils/logger.js");

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
        headers: {
          "x-custom-header": "REQUESTED GET",
        },
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
        headers: {
          "x-custom-header": "REQUESTED POST",
        },
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
        headers: {
          "x-custom-header": "REQUESTED OTHER",
        },
        body: JSON.stringify(body),
      };
      return response;
  }
};
