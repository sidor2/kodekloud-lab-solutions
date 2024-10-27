## Building and Managing APIs with AWS API Gateway

The DevOps team needs to deploy a Python Lambda function using a fully automated CI/CD pipeline with AWS CodePipeline. The function will be triggered via an API Gateway. The goal is to set up a continuous delivery pipeline that deploys changes automatically whenever updates are made to the code.

1. Create a CodeCommit repository named `nautilus-lambda-repo` to store the Lambda function's source code, the source code is available on AWS client host under /root/pyapp directory.

2. Configure SSH Git Credentials so that you can push the changes to this repo from the AWS Client Host. You may need to create an SSH key pair on AWS Client Host.

```
aws iam upload-ssh-public-key --user-name nautilus-devops --ssh-public-key-body file:///home/user/.ssh/id_rsa.pub
```

3. Create a Lambda function named `nautilus-lambda-function` with Python as the runtime, you need not to add any code there as pipeline should take care of that.

4. Create an API Gateway (REST API) to trigger the Lambda function. 
    - Name the API `nautilus-api-gateway`
    - create a GET method to invoke the Lambda function also create a new stage for it named `test`.

5. Set up a CodeBuild named `nautilus-build-project` and a CodePipeline named `nautilus-pipeline` with two stages: Source (CodeCommit) and Build (CodeBuild). 
    - The pipeline should automatically execute if any changes to the source code are pushed.

6. Verify that the API Gateway triggers the Lambda function and returns the correct response.