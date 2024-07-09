#!/bin/bash  
# This is Shebang script using /bin/bash to run commands
# A shebang (also known as a hashbang or sha-bang) is the #! character sequence at the beginning of a script in Unix-like operating systems.

################################################################################################
# Jenkins Installation
################################################################################################

apt update -y  # It will update server
apt install openjdk-17-jre -y # It will install Openjdk

curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null  # This will update the repository for jenkins

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null  # This will update the repository for jenkins

apt-get update -y # This will update the server

apt-get install jenkins -y # This will install jenkins

echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#####################################################################################################
# Terraform Installation
#####################################################################################################

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y

sudo apt install terraform -y

###############################################################################################################
#                   Docker Installation
###############################################################################################################

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

##########################################################################################
# Other installation
##########################################################################################

usermod -aG docker jenkins
apt install unzip -y

###########################################################################################
# To install AWS CLI V2
###########################################################################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

###########################################################################################
# To install kubectl
###########################################################################################
 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

 curl -LO https://dl.k8s.io/release/v1.28.3/bin/linux/amd64/kubectl

 curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
   
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

###########################################################################################
# To install maven
###########################################################################################
apt update -y
apt install maven -y

sudo chmod 666 /var/run/docker.sock


sudo systemctl restart jenkins