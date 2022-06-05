#!/bin/bash
echo "aws ecr get-login-password --profile <aws-profile-with-access-to-ecr-repo> | docker login --username AWS --password-stdin <aws.ecr.path>" >> ~/.bashrc
echo "make sure you have done the aws sso login: aws sso login --profile=<aws-profile-with-access-to-ecr-repo>"
echo "(or whatever profile you normally use)"
echo "close the terminal session and start a new one"