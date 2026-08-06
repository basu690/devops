# Jenkins Installation and Configuration on AWS EC2

## Engineer
RK Reddy

## Objective
Install and configure Jenkins on an AWS EC2 Ubuntu instance.

## Infrastructure Details
- Cloud Provider: AWS
- Service: EC2
- Instance Name: jenkins-master
- Instance Type: t3.micro
- Operating System: Ubuntu
- Java Version: OpenJDK 21
- Jenkins Version: 2.568.2
- Jenkins Port: 8080

## Security Group Configuration
- SSH: TCP 22, restricted to administrator IP
- Jenkins: TCP 8080, restricted to administrator IP
- HTTP: TCP 80
- HTTPS: TCP 443

## Java Installation

Commands executed:

```bash
sudo apt update
sudo apt install -y fontconfig openjdk-21-jre
java -version