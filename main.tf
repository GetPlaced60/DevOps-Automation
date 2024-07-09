#######################################################################################
# AWS VPC Creation
#######################################################################################

resource "aws_vpc" "our-vpc" {   # "aws-vpc" is api which helps tocreate AWS VPC and "our-vpc" is code name
  cidr_block = var.vpc_cidr_value   # this is the cidr block which will specify the ip addresses
  tags = {  # it will tag the resource
    Name : "Our-VPC"   # this is the name of the VPC
    Environment : var.environment  # this is the environment in which we are launching the VPC
  }
}

########################################################################################
# AWS IGW CREATION
########################################################################################

resource "aws_internet_gateway" "our-igw" { # "aws_internet_gateway" will help to create igw abd our-igw is code name 
  vpc_id = aws_vpc.our-vpc.id  # This will attach igw to the vpc
  tags = {  # This will tag the igw
    Name : "Our-IGW" # this is the name of the IGW
    Environment : var.environment # this is the environment in which we are launching the IGW
  }
}

########################################################################################
# AWS SUBNET CREATION
########################################################################################

resource "aws_subnet" "our-public-subnet" {  # "aws_subnet" is api help to create api
  vpc_id                  = aws_vpc.our-vpc.id  # creating subnet inside this vpc
  cidr_block              = var.public-subnet-cidr-value # This will be the CIDR for subnet fetched from variable.tf
  map_public_ip_on_launch = true  # this will provide public ip address to instance when launched this subnet
  availability_zone       = data.aws_availability_zones.available.names[0] # Subnet will span this az
  tags = { # This is the list of tags
    Name : "Our-Public-Subnet" # subnet name
    Environment : var.environment # subnet environment
  }
}

resource "aws_subnet" "our-public-subnet2" {  # "aws_subnet" is api help to create api
  vpc_id                  = aws_vpc.our-vpc.id  # creating subnet inside this vpc
  cidr_block              = var.public-subnet-cidr-value2 # This will be the CIDR for subnet fetched from variable.tf
  map_public_ip_on_launch = true  # this will provide public ip address to instance when launched this subnet
  availability_zone       = data.aws_availability_zones.available.names[1] # Subnet will span this az
  tags = { # This is the list of tags
    Name : "Our-Public-Subnet" # subnet name
    Environment : var.environment # subnet environment
  }
}

resource "aws_subnet" "our-private-subnet" {
  vpc_id                  = aws_vpc.our-vpc.id
  cidr_block              = var.private-subnet-cidr-value
  map_public_ip_on_launch = false # This is private subnet so no need of public ip
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name : "Our-Private-Subnet"
    Environment : var.environment
  }
}

resource "aws_subnet" "our-private-subnet2" {
  vpc_id                  = aws_vpc.our-vpc.id
  cidr_block              = var.private-subnet-cidr-value2
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name : "Our-Private-Subnet2"
    Environment : var.environment
  }
}

########################################################################################
# AWS ROUTE TABLE CREATION
########################################################################################

resource "aws_route_table" "our-public-route-table" { # creating a new route table with help of "aws_route_table"
  vpc_id = aws_vpc.our-vpc.id # new route table will be created in this vpc 
  tags = {
    Name : "Our-Public-Route-Table"
    Environment : var.environment
  }
}

resource "aws_route_table" "our-public-route-table2" { # creating a new route table with help of "aws_route_table"
  vpc_id = aws_vpc.our-vpc.id # new route table will be created in this vpc 
  tags = {
    Name : "Our-Public-Route-Table"
    Environment : var.environment
  }
}
resource "aws_route_table" "our-private-route-table" {
  vpc_id = aws_vpc.our-vpc.id
  tags = {
    Name : "Our-Private-Route-Table"
    Environment : var.environment
  }
}

resource "aws_route_table" "our-private-route-table2" {
  vpc_id = aws_vpc.our-vpc.id
  tags = {
    Name : "Our-Private-Route-Table"
    Environment : var.environment
  }
}

########################################################################################
# AWS SUBNET ROUTE TABLE ASSOCIATION
########################################################################################

resource "aws_route_table_association" "our-public-route-table-association" { # This will associate route table with subnet
  subnet_id      = aws_subnet.our-public-subnet.id # This will associate route table with subnet
  route_table_id = aws_route_table.our-public-route-table.id # This is the route table which will be associated with
}

resource "aws_route_table_association" "our-public-route-table-association2" { # This will associate route table with subnet
  subnet_id      = aws_subnet.our-public-subnet2.id # This will associate route table with subnet
  route_table_id = aws_route_table.our-public-route-table2.id # This is the route table which will be associated with
}

resource "aws_route_table_association" "our-private-route-table-association" {
  subnet_id      = aws_subnet.our-private-subnet.id
  route_table_id = aws_route_table.our-private-route-table.id
}

resource "aws_route_table_association" "our-private-route-table-association2" {
  subnet_id      = aws_subnet.our-private-subnet2.id
  route_table_id = aws_route_table.our-private-route-table2.id
}

########################################################################################
# AWS ROUTE ADDITION INTO ROUTE TABLES
########################################################################################

resource "aws_route" "our-public-route" { # This will create routes inside route table
  route_table_id         = aws_route_table.our-public-route-table.id # this the route table in which routes will be created
  destination_cidr_block = "0.0.0.0/0" # this is the route for internet connections
  gateway_id             = aws_internet_gateway.our-igw.id # This is internet gateway to the route traffic to internet connections
}

resource "aws_route" "our-public-route2" { # This will create routes inside route table
  route_table_id         = aws_route_table.our-public-route-table2.id # this the route table in which routes will be created
  destination_cidr_block = "0.0.0.0/0" # this is the route for internet connections
  gateway_id             = aws_internet_gateway.our-igw.id # This is internet gateway to the route traffic to internet connections
}

########################################################################################
# AWS SECURITY GROUP
########################################################################################

resource "aws_security_group" "our-security-group" { # This will create security group in vpc
  name = "Our-Security-Group" # name for security group
  description = "Our Security Group" # description for SG
  vpc_id = aws_vpc.our-vpc.id # Vpc in which this SG will be created
  tags = {
    Name : "Our-Security-Group" # Tags for security group
    Environment : var.environment # Environment for the security group
  }
  ingress {  # This is for inbound rules in SG
    from_port   = 22 # This is syntax to open port 22
    to_port     = 22
    protocol    = "tcp" # its using SSH but we specify TCP here 
    cidr_blocks = ["0.0.0.0/0"] # To allow traffic from anywhere IPV4
  }
  ingress { 
    from_port   = 80  # This is syntax to open port 80
    to_port     = 80
    protocol    = "tcp" # its using HTTP but we specify TCP here
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 8080 # This is syntax to open port 8080
    to_port     = 8080
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {  # This is syntax to open ports for outbound traffic
    from_port   = 0 # we are allowing all traffic for outbound
    to_port     = 0 # we are allowing all traffic for outbound
    protocol    = "-1" # all Protocols
    cidr_blocks = ["0.0.0.0/0"] # anywhere ipv4
    ipv6_cidr_blocks = ["::/0"] # anywhere ipv6
  }
}

resource "aws_security_group" "our-security-group-for-nexus" { # This will create security group in vpc
  name = "Our-Security-Group-for-nexus" # name for security group
  description = "Our Security Group" # description for SG
  vpc_id = aws_vpc.our-vpc.id # Vpc in which this SG will be created
  tags = {
    Name : "Our-Security-Group-for-nexus" # Tags for security group
    Environment : var.environment # Environment for the security group
  }
  ingress {  # This is for inbound rules in SG
    from_port   = 22 # This is syntax to open port 22
    to_port     = 22
    protocol    = "tcp" # its using SSH but we specify TCP here 
    cidr_blocks = ["0.0.0.0/0"] # To allow traffic from anywhere IPV4
  }
  ingress { 
    from_port   = 80  # This is syntax to open port 80
    to_port     = 80
    protocol    = "tcp" # its using HTTP but we specify TCP here
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 8081 # This is syntax to open port 8080
    to_port     = 8081
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {  # This is syntax to open ports for outbound traffic
    from_port   = 0 # we are allowing all traffic for outbound
    to_port     = 0 # we are allowing all traffic for outbound
    protocol    = "-1" # all Protocols
    cidr_blocks = ["0.0.0.0/0"] # anywhere ipv4
    ipv6_cidr_blocks = ["::/0"] # anywhere ipv6
  }
}

resource "aws_security_group" "our-Security-Group-for-sonar" { # This will create security group in vpc
  name = "OOur-Security-Group-for-sonar" # name for security group
  description = "Our Security Group" # description for SG
  vpc_id = aws_vpc.our-vpc.id # Vpc in which this SG will be created
  tags = {
    Name : "Our-Security-Group-for-sonar" # Tags for security group
    Environment : var.environment # Environment for the security group
  }
  ingress {  # This is for inbound rules in SG
    from_port   = 22 # This is syntax to open port 22
    to_port     = 22
    protocol    = "tcp" # its using SSH but we specify TCP here 
    cidr_blocks = ["0.0.0.0/0"] # To allow traffic from anywhere IPV4
  }
  ingress { 
    from_port   = 80  # This is syntax to open port 80
    to_port     = 80
    protocol    = "tcp" # its using HTTP but we specify TCP here
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 9000 # This is syntax to open port 8080
    to_port     = 9000
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {  # This is syntax to open ports for outbound traffic
    from_port   = 0 # we are allowing all traffic for outbound
    to_port     = 0 # we are allowing all traffic for outbound
    protocol    = "-1" # all Protocols
    cidr_blocks = ["0.0.0.0/0"] # anywhere ipv4
    ipv6_cidr_blocks = ["::/0"] # anywhere ipv6
  }
}