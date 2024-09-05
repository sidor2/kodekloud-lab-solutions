### Automating Infrastructure Deployment with AWS Cloud Formation

Create a Lambda function named datacenter-lambda.
Use the Runtime Python.
The function should print the body Welcome to KKE AWS Labs!.
Ensure the status code is 200.
Create and use the IAM role named lambda_execution_role.

```
aws cloudformation create-stack --stack-name nautilus-lambda-app --template-body file://nautilus-lambda.yml --capabilities CAPABILITY_NAMED_IAM
```
```
aws lambda invoke --function-name nautilus-lambda --payload '{}' response.json
```