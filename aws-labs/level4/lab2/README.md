## CI/CD Automation Using AWS Code Pipeline

1. Create an S3 bucket named *datacenter-deployment-28530*. Configure the bucket to serve static website content and ensure the bucket is publicly accessible.

2. Create an AWS CodeCommit repository named datacenter-webapp-repo. 
- Configure SSH Git Credentials so that you can push the changes to this repo from the AWS Client Host. 
- You may need to create an SSH key pair on AWS Client Host.

3. Create an AWS CodePipeline named *datacenter-webapp-pipeline* with the following stages:

- **Source:** 
    - Source Provider - AWS CodeCommit
    - Repository Name - *datacenter-webapp-repo*.

- **Build:** 
    - Build Provider - AWS CodeBuild, 
    - Project Name - *datacenter-build-project*, 
    - Environment - Managed image, aws/codebuild/amazonlinux2-x86_64-standard:5.0
    - Set the image version to always use the latest image for this runtime version. 
    - Create the role named *datacenter-codebuild-role*. 
    - Create a policy to allow necessary access to push changes to the s3 bucket, 
    - Attach that policy to *datacenter-codebuild-role* role. 
    - Insert the necessary build commands in the build commands section to directly upload the *index.html* file to the S3 bucket.

### Expected Outcome:

- When a change is pushed to the *datacenter-webapp-repo* under the master branch, the pipeline should automatically build the project using the inserted build commands and deploy the *index.html* file to the *datacenter-deployment-28530* bucket. 
- The S3 bucket should be configured to allow public access, and the website should be accessible via the S3 static website URL.
