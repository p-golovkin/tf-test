module vpc {
  source = "../vpc/us-east-1"
}


resource "aws_security_group" "EC2-sg" {
  name        = "EC2-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "EC2-sg"
  }
}

resource "aws_security_group" "EFS-sg" {
  name        = "EFS-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "NFS"
    from_port        = 0
    to_port          = 2049
    protocol         = "tcp"
    security_groups = [aws_security_group.EC2-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "EFS-sg"
  }
}

resource "aws_efs_file_system" "tf_efs" {
  creation_token = "lesson-03"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "lesson-03"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  file_system_id = aws_efs_file_system.tf_efs.id
  subnet_id      = module.vpc.private_subnet_id
  security_groups = [aws_security_group.EFS-sg.id]
}
