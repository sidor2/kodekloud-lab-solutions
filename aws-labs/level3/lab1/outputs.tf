output "kodek_ec2_sg" {
  value = tolist(data.aws_instance.kodek_ec2.security_groups)[0]
}

output "kodek_ec2_sg_id" {
  value = "${data.aws_security_group.kodek_ec2_sg.id}"
}

output "kodek_rds" {
  value = aws_db_instance.kodek_rds.endpoint
}

output "kodek_ec2" {
    value = "${data.aws_instance.kodek_ec2.public_dns}/index.php"
}