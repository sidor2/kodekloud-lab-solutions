## Deploying and Managing Applications with AWS Elastic Beanstalk

The DevOps team is working on deploying a Python application on AWS Elastic Beanstalk using AWS CodePipeline for CI/CD automation. The application retrieves an API key from AWS Secrets Manager, so sensitive information must be securely managed. The goal of this task is to set up a complete pipeline with CodeCommit as the source, Elastic Beanstalk for deployment, and Secrets Manager to store the API key.

1. Create a CodeCommit repository named nautilus-code-repo to store the Python app's source code, the source code is available on AWS client host under /root/pyapp directory. 

2. Configure SSH Git Credentials so that you can push the changes to this repo from the AWS Client Host. 
    - You may need to create an SSH key pair on AWS Client Host.
```
vim ~/.ssh/config

# Add the following lines:
Host git-codecommit.*.amazonaws.com
  User APKAEIBAERJR2EXAMPLE 
  IdentityFile ~/.ssh/codecommit_key
```

3. Create a secret in AWS Secrets Manager named nautilus-api-key-secret, and store an API key as API_KEY_SECRET_NAME=supersecretapikey123.

4. Create an Elastic Beanstalk application named nautilus-app and an environment named Nautilus-app-env using Python as the platform. This will host the application.

5. Set up a CodePipeline named nautilus-pipeline with two stages: Source (CodeCommit) and Deploy (Elastic Beanstalk). 
    - The pipeline should automatically deploy any changes to the Elastic Beanstalk environment.

6. Ensure the application retrieves the API key from Secrets Manager and is accessible through the Elastic Beanstalk environment's URL.

7. Verify that the application is running correctly and using the API key from Secrets Manager.