### Load Balancing EC2 Instances with Application Load Balancer

1. Create a security group named <i>datacenter-sg</i> to open port 80 for the default security group (which will be attached to the ALB). Attach <i>datacenter-sg</i> security group to the EC2 instance.

2. Create an EC2 instance named <i>datacenter-ec2</i>. Use any available Ubuntu AMI to create this instance. Configure the instance to run a user data script during its launch.
    
    This script should:

    - Install the Nginx package.
    - Start the Nginx service.

3. Set up an Application Load Balancer named <i>datacenter-alb</i>. Attach default security group to the same.

4. Create a target group named <i>datacenter-tg</i>.

5. The ALB should route traffic on port 80 to port 80 of the <i>datacenter-ec2</i> instance.

6. Make appropriate changes in the default security group attached to the ALB if necessary. Eventually, the Nginx server running under <i>datacenter-ec2</i> instance must be accessible using the ALB DNS.

