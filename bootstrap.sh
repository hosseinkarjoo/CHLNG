#!/bin/bash

read -p 'access_key: ' AK
read -p 'secret_key: ' SK

cat ./tmp/aws_creds.template > aws_creds
cat ./tmp/variables.template > variables.tf

sed -ie "s/ACCESS-KEY/$AK/g" ./aws_creds
sed -ie "s|SECRET-KEY|$SK|g"  ./aws_creds
sed -ie "s/ACCESS-KEY/$AK/g" ./variables.tf
sed -ie "s|SECRET-KEY|$SK|g" ./variables.tf
