set -e

export $(grep -v '^#' .env.local | xargs)
echo "Using AWS ACCOUNT: $AWS_PROFILE for $AWS_ACCOUNT_ID"

# Environments
case "$1" in
  dev) 
    WORKSPACE="dev"
    ;;
  stage) 
    WORKSPACE="stage"
    ;;
  prod) 
    WORKSPACE="prod"
    ;;
  *)
    echo $"Usage: $0 {dev|stage|prod}"
    exit 1
esac
echo "Running tf-deploy on ${WORKSPACE}"

# Terraform state, bucket name
terraform_state_bucket="terraform-remote-config-$AWS_ACCOUNT_ID"
echo "Using Terraform state bucket: $terraform_state_bucket"

pushd terraform

# Cleanup .terraform
rm -rf .terraform/

# Get terraform packages
AWS_PROFILE="$AWS_PROFILE" terraform init -backend-config bucket="${terraform_state_bucket}"

# If the workspace does not exist, create it.
if ! AWS_PROFILE="$AWS_PROFILE" terraform workspace select ${WORKSPACE}; then
  AWS_PROFILE="$AWS_PROFILE" terraform workspace new ${WORKSPACE}
fi
AWS_PROFILE="$AWS_PROFILE" terraform apply -auto-approve
AWS_PROFILE="$AWS_PROFILE" terraform output > ../.env

popd
echo "DONE!"