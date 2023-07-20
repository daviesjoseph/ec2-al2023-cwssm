#!/bin/bash

INSTALL=$1

if [ "$INSTALL" = true ]; then
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  sudo start amazon-ssm-agent
  sudo systemctl enable amazon-ssm-agent
else
  echo "Skip SSM installation"
fi
