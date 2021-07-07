output "vpc_id" {
    value = aws_vpc.vpc-tf.id
    description = "VPC ID"
}

output "private_subnet_id" {
    value = aws_subnet.tf_private_sn.id
}

output "puiblic_subnet_id" {
    value = aws_subnet.tf_public_sn.id
}

