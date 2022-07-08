#!/bin/bash

read -p 'access_key: ' AK
read -p 'secret_key: ' SK

echo 'PATH=$PATH:/usr/local/bin' >> ~/.bashrc && source ~/.bashrc
if which terraform
then
  echo $(terraform version)
  sleep 2
else
  if echo $PATH | grep /usr/bin:
  then 
    echo found PATH /use/bin
    echo installing dependencies:
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform
#    m
    if which terraform
    then
      echo "TERRAFORM IS INSTALLED"
      sleep 2
    else
      echo "ERROR terraform is not installed (check your PATH)"
      sleep 2
    fi
  else
    "echo add /usr/bin to PATH"
     sleep 2
  fi
fi
if which ansible
then
  echo "ansible version"
  sleep 2
else
  sudo yum install ansible -y
  if which ansible
  then
    echo "ANSIBLE IS INSTALLED"
    echo $(ansible --version)
    sleep 2
  else
    echo "ERROR ansible is not installed (check your PATH)"
    sleep 2
  fi
fi
if which aws
then
  echo "AWS cli is installed"
  sleep 2
else
  if which pip3 
  then
    echo "PIP3 is installed"
    sleep 2
  else
    sudo yum install python3-pip -y
  fi
  sudo pip3 install awscli
  if which aws
  then
    echo "AWSCLI IS INSTALLED"
    echo $(aws version)
    sleep 2
  else
    echo "ERROR awscli is not installed (check your PATH)"
    cp /usr/local/bin/aws /usr/bin/aws
  fi
fi






cat ./tmp/aws_creds.template > aws_creds
cat ./tmp/variables.template > variables.tf

sed -i "s/ACCESS-KEY/$AK/g" ./aws_creds
sed -i "s|SECRET-KEY|$SK|g"  ./aws_creds
sed -i "s/ACCESS-KEY/$AK/g" ./variables.tf
sed -i "s|SECRET-KEY|$SK|g" ./variables.tf

if [ ! -d  ~/.aws]; then
  mkdir ~/.aws
fi
cp aws_creds ~/.aws/credentialsi

echo "DONE"
