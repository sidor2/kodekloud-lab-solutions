### Managing EC2 Access with S3 Role-based Permissions
- creating a private s3 bucket
- adding an instance profile to an existing EC2 instance

#### create an SSH key if needs to be
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa_nautilus
```

#### run terraform
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

#### attach the profile to the EC2
```
aws ec2 associate-iam-instance-profile --instance-id <instance-id> --iam-instance-profile Name=xfusion-instance-profile
```

