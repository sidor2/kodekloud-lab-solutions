### Automating Infrastructure Deployment with AWS Cloud Formation
```
aws cloudformation create-stack --stack-name nautilus-lambda-app --template-body file://nautilus-lambda.yml --capabilities CAPABILITY_NAMED_IAM
```
```
aws lambda invoke --function-name nautilus-lambda --payload '{}' response.json
```