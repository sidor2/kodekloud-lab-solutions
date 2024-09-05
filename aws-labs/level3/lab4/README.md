### Deploying Containerized Applications with Amazon ECS

Create a Private ECR Repository:

Create a private ECR repository named nautilus-ecr to store Docker images.
Build and Push Docker Image:

Use the Dockerfile located at /root/pyapp on the aws-client host.
Build a Docker image using this Dockerfile.
Tag the image with latest tag.
Push the Docker image to the nautilus-ecr repository.
Create and Configure ECS cluster:

Create an ECS cluster named nautilus-cluster using the Fargate launch type.
Create an ECS Task Definition:

Define a task named nautilus-taskdefinition using the Docker image from the nautilus-ecr ECR repository.
Specify necessary CPU and memory resources.
Deploy the Application Using ECS Service:

Create a service named nautilus-service on the nautilus-cluster to run the task.
Ensure the service runs at least one task.