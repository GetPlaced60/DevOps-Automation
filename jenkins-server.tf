################################################################################################################################################################################################################################################################################################################################
# Fetching latest AMI ID of ubuntu 22.04
#################################################################################################################


data "aws_ami" "latest" {     # aws_ami helps to get AMI ID of the os
    most_recent = true  # this is the filter for most recent Ami
   
    filter {   # this is the filter for virtualization type
      name = "virtualization-type"
      values = ["hvm"]
    }
    filter {  # this is the filter for AMI name of the OS which can be found in AMI section in EC2
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
     owners = ["099720109477"]  # this is the owner of the OS, which can be found in AMI section in EC2
}


################################################################################################################################################################################################################################################################################################################################################################################################
# Fetching latest AMI ID of Debian 12
################################################################################################################################################################################################################################################################################################################################################################
/*
data "aws_ami" "latest" {
    most_recent = true
   
    filter {
      name = "architecture"
      values = ["x86_64"]
    }
    filter {
        name = "name"
        values = ["debian-12-amd64-*-*"]
    }
     owners = ["136693071363"]
}
*/
##################################################################################################################
# Fetching latest AMI ID of Amazon linux 2023
##################################################################################################################
/*
data "aws_ami" "latest" {
    most_recent = true
   
    filter {
      name = "architecture"
      values = ["x86_64"]
    }
    filter {
        name = "name"
        values = ["al2023-ami-*-kernel-*-x86_64"]
    }
    owners = ["137112412989"]
}
*/
###########################################################################################################
# Creating EC2 instance out of this latest AMI
###########################################################################################################

resource "aws_instance" "jenkins-server" {   # we are creating a new instance for jenkins-server
    ami = data.aws_ami.latest.id    # we are using the latest ami that we fetched earlier
    instance_type = "t3.medium"     # This is the type of the instance we are creating
    subnet_id = aws_subnet.our-public-subnet.id   # this is the id of the subnet we are using to launch the instance
    user_data = file("./jenkins-server.sh")  # this is the script that will be executed during the creation of the instance
    key_name = "terraform" # this is the key name that we have created in console
    iam_instance_profile = aws_iam_instance_profile.our-instance-profile.name
    security_groups = [aws_security_group.our-security-group.id] # this is security grp in which we have openend ports
    root_block_device {
      volume_size = 20
    }

    tags = {
        Name = "jenkins-server"  # this will provide name to instance 
    }
}


