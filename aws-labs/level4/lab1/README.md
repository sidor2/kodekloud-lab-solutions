## Implementing Auto Scaling for High Availability in AWS

1. Create an EC2 launch template named devops-launch-template that specifies the configuration for the EC2 instances, including the Amazon Linux 2 AMI, t2.micro instance type, and a security group that allows HTTP traffic on port 80.

2. Add a User Data script to the launch template to install Nginx on the EC2 instances when they are launched. The script should install Nginx, start the Nginx service, and enable it to start on boot.

3. Create an Auto Scaling Group named <i>devops-asg</i> that uses the launch template and ensures a minimum of 1 instance, desired capacity is 1 instance and a maximum of 2 instances are running based on CPU utilization. Set the target CPU utilization to 50%.

4. Create a target group named <i>devops-tg</i>, an Application Load Balancer named <i>devops-alb</i> and configure it to listen on port 80. Ensure the ALB is associated with the Auto Scaling Group and distributes traffic across the instances.

5. Configure health checks on the ALB to ensure it routes traffic only to healthy instances.

6. Verify that the ALB's DNS name is accessible and that it displays the default Nginx page served by the EC2 instances.