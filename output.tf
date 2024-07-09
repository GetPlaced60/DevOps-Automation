output "VPC-id" {   # This will output the value of vpc id in terminal
    value = aws_vpc.our-vpc.id 
}

output "Instance-id" { # This will output the value of instance id in terminal
    value = aws_instance.jenkins-server.id
}

output "jenkins-ip" { # This will output the value of instance public ip in terminal
    value = aws_instance.jenkins-server.public_ip
}

output "nexus-ip" { # This will output the value of instance id in terminal
    value = aws_instance.nexus-server.public_ip
}

output "sonar-ip" { # This will output the value of instance id in terminal
    value = aws_instance.sonar-server.public_ip
}