resource "aws_vpc" "vpc-tf" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name ="vpc-tf"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-tf.id

  tags = {
    Name = "tf-gw"
  }
}

resource "aws_route_table" "tf_private_rt" {
  vpc_id = aws_vpc.vpc-tf.id
  route = []
  tags = {
    Name = "tf_private_rt"
  }
}

resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.vpc-tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "tf_public_rt"
  }
}
resource "aws_subnet" "tf_public_sn" {
  vpc_id = aws_vpc.vpc-tf.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf_public_sn"
  }

}

resource "aws_subnet" "tf_private_sn" {
  vpc_id = aws_vpc.vpc-tf.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "tf_private_sn"
  }

}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.tf_private_sn.id
  route_table_id = aws_route_table.tf_private_rt.id
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.tf_public_sn.id
  route_table_id = aws_route_table.tf_public_rt.id
}