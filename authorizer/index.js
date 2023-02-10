const AWS = require("aws-sdk");
const sts = new AWS.STS();

function generatePolicy(effect, accountId) {
  // effect = Allow|Deny
  return {
    principalId: "terraform-api-gateway",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: effect,
          Resource: `arn:aws:execute-api:us-west-2:${accountId}:*/*/*/*`,
        },
      ],
    },
    context: {
      simpleAuth: true,
      whateverElse: "to pass downstream",
    },
  };
}

module.exports.handler = async (event, context) => {
  const accountId = (await sts.getCallerIdentity().promise()).Account;
  console.log(`The AWS account ID is: ${accountId}`);

  var token = event.authorizationToken;
  console.log(`**** authorizationToken=>`, token);
  console.log(`**** event =>`, event);

  if (token.includes("Bearer ")) {
    return generatePolicy("Allow", accountId);
  } else {
    return generatePolicy("Deny", accountId);
    // return "Unauthorized";
  }
};
