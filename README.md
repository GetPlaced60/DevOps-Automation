# DevOps Automation for Microservices Application

This repository provides a comprehensive guide to setting up DevOps automation for a microservice application using SonarQube, Nexus, and Jenkins on AWS. The infrastructure is provisioned using Terraform, Docker, and Kubernetes (EKS), ensuring a scalable, reproducible, and efficient setup.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Architecture Overview](#architecture-overview)
- [Setup Instructions](#setup-instructions)
  - [1. Configure AWS Credentials](#1-configure-aws-credentials)
  - [2. Clone the Repository](#2-clone-the-repository)
  - [3. Setup Terraform](#3-setup-terraform)
  - [4. Provision Infrastructure](#4-provision-infrastructure)
  - [5. Build Docker Images](#5-build-docker-images)
  - [6. Deploy Kubernetes Cluster on EKS](#6-deploy-kubernetes-cluster-on-eks)
  - [7. Install and Configure SonarQube](#7-install-and-configure-sonarqube)
  - [8. Install and Configure Nexus](#8-install-and-configure-nexus)
  - [9. Install and Configure Jenkins](#9-install-and-configure-jenkins)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project automates the deployment of a DevOps pipeline for a microservices application using SonarQube, Nexus, and Jenkins on AWS. The infrastructure is provisioned using Terraform, Docker for containerization, and Kubernetes (EKS) for orchestration.

## Prerequisites

Before starting, ensure you have the following:

- An AWS account with appropriate permissions
- AWS CLI configured with your credentials
- Terraform installed (version 0.12+)
- Docker installed
- kubectl installed and configured
- Basic knowledge of AWS services, Terraform, Docker, and Kubernetes

## Architecture Overview

The architecture includes:

- **SonarQube**: Static code analysis and continuous inspection of code quality
- **Nexus**: Repository manager for binaries and build artifacts
- **Jenkins**: Continuous Integration/Continuous Deployment (CI/CD) server

All components are deployed within an AWS EKS cluster, utilizing Docker for containerization.

## Setup Instructions

### 1. Configure AWS Credentials

Ensure your AWS CLI is configured with the necessary credentials:

```sh
aws configure
```

### 2. Clone the Repository

Clone this repository to your local machine:

```sh
git clone https://github.com/yourusername/devops-automation-microservice.git
cd devops-automation-microservice
```

### 3. Setup Terraform

Initialize Terraform in the project directory:

```sh
terraform init
```

### 4. Provision Infrastructure

Apply the Terraform configuration to provision the necessary infrastructure:

```sh
terraform apply
```

Review the planned changes and confirm by typing `yes`.

### 5. Build Docker Images

Build Docker images for SonarQube, Nexus, and Jenkins:

```sh
docker build -t yourusername/sonarqube ./sonarqube
docker build -t yourusername/nexus ./nexus
docker build -t yourusername/jenkins ./jenkins
```

Push the images to a Docker registry (Docker Hub, ECR, etc.):

```sh
docker push yourusername/sonarqube
docker push yourusername/nexus
docker push yourusername/jenkins
```

### 6. Deploy Kubernetes Cluster on EKS

Create and configure the EKS cluster using Terraform:

```sh
terraform apply -target=module.eks
```

Update your kubeconfig to use the new EKS cluster:

```sh
aws eks update-kubeconfig --name your-cluster-name
```

### 7. Install and Configure SonarQube

Deploy SonarQube using the provided Kubernetes manifests:

```sh
kubectl apply -f k8s/sonarqube
```

Access SonarQube via the public IP or domain assigned.

### 8. Install and Configure Nexus

Deploy Nexus using the provided Kubernetes manifests:

```sh
kubectl apply -f k8s/nexus
```

Access Nexus via the public IP or domain assigned.

### 9. Install and Configure Jenkins

Deploy Jenkins using the provided Kubernetes manifests:

```sh
kubectl apply -f k8s/jenkins
```

Access Jenkins via the public IP or domain assigned.

## Usage

1. **SonarQube**: Configure your projects to use SonarQube for code quality analysis.
2. **Nexus**: Use Nexus to store and manage your build artifacts.
3. **Jenkins**: Set up Jenkins pipelines for your CI/CD workflows.

## Troubleshooting

- Ensure all Kubernetes pods are running and accessible.
- Verify security group rules to allow necessary traffic.
- Check logs for SonarQube, Nexus, and Jenkins for any error messages.

## Contributing

We welcome contributions! Please fork the repository and create a pull request with your changes. Ensure you adhere to the project's coding standards and guidelines.


Happy DevOps Automation! If you have any questions or issues, please feel free to open an issue in this repository.
---

### Authored by [Hitesh Vishwas Pogade](https://github.com/GetPlaced60)
