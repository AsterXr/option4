output "vpc_id" {
  value       = aws_vpc.option4-vpc.id
  description = "VPC id"
}

output "asg_id" {
  value       = aws_autoscaling_group.option4-asg.id
  description = "ASG id"
}
