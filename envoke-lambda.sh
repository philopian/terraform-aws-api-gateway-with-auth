pushd terraform
echo "Envoking the live lambda function..."
aws lambda invoke --region=us-west-2 --function-name=$(terraform output -raw function_name) response.json | jq 

echo "\nLambda's response..."
cat response.json | jq
popd