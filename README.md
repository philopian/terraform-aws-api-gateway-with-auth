#  REST API made with Terraform
- Very Simple example of setting up an AWS API Gateway with a Custom Authorizer to only allow request that contain `Authorization: Bearer <anything-here>` header.
- **NOTE**: you should update logic in the Custom Authorizer to hit an authorizatin server to parse the JWT
- Here are a few JSON Web Token (JWT) authentication services:
  1. Auth0: A cloud-based platform that provides identity management and authentication services, including JWT authentication.
  2. Okta: A cloud-based identity and access management platform that provides JWT authentication as part of its services.
  3. Firebase Authentication: A service provided by Google Firebase that provides JWT authentication for mobile and web applications.
  4. Microsoft Azure Active Directory B2C: A cloud-based identity and access management service provided by Microsoft that supports JWT authentication.
  5. AWS Cognito: An Amazon Web Services service that provides JWT authentication for web and mobile applications.
  6. JWT.io: An open-source platform that provides JWT authentication services and tools, including a JWT debugger and generator.


# How to get started

## Setup
1. In AWS create a S3 Bucket with the format `terraform-remote-config-<AWS_ACCOUNT_ID>`, this will house all your remote terraform state in separate workspaces. Manually create this for each AWS account you want to run this. We are creating this manually because we can leverage this S3 bucket for other projects
2. Create a `.env.local` with 2 values
  ```shell
  AWS_ACCOUNT_ID="000000000000"
  AWS_PROFILE="default" # ?? most likely you are using the "default" profile
  ```
3. Install [Terraform](https://www.terraform.io) with at least version `1.3`. [TFSwitch](https://tfswitch.warrensbox.com) is a great terraform version manager you might want to look into using.


## Deploy/Destroy all the AWS resources
```shell
# Deploy with (dev|stage|prod)
$ ./deploy.sh dev

# Destroy with (dev|stage|prod)
$ ./kill.sh dev
```





