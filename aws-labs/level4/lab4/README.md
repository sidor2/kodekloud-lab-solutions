You are required to use AWS CloudFormation to deploy the necessary resources in your AWS account. The stack name must be devops-priority-stack and it should create the following resources:

1. Two SQS queues named devops-High-Priority-Queue and devops-Low-Priority-Queue.
2. An SNS topic named devops-Priority-Queues-Topic.
3. A Lambda function named devops-priorities-queue-function that will consume messages from the SQS queues. The Lambda function code is provided in /root/index.py on the AWS client host.
4. An IAM role named lambda_execution_role that provides the necessary permissions for the Lambda function to interact with SQS and SNS.

```
aws cloudformation create-stack --stack-name datacenter-priority-stack --template-body file:///root/datacenter-priority-stack.yml --capabilities CAPABILITY_NAMED_IAM
```

- Once the stack is deployed, to test the same you can publish messages to the SNS topic, invoke the Lambda function and observe the order in which they are processed by the Lambda function. The high-priority message must be processed first.

```
topicarn=$(aws sns list-topics --query "Topics[?contains(TopicArn, 'devops-Priority-Queues-Topic')].TopicArn" --output text)
aws sns publish --topic-arn $topicarn --message 'High Priority message 1' --message-attributes '{"priority" : { "DataType":"String", "StringValue":"high"}}'
aws sns publish --topic-arn $topicarn --message 'High Priority message 2' --message-attributes '{"priority" : { "DataType":"String", "StringValue":"high"}}'
aws sns publish --topic-arn $topicarn --message 'Low Priority message 1' --message-attributes '{"priority" : { "DataType":"String", "StringValue":"low"}}'
aws sns publish --topic-arn $topicarn --message 'Low Priority message 2' --message-attributes '{"priority" : { "DataType":"String", "StringValue":"low"}}'
```