#!bin/bash

if [-z $1] ; then
echo "Enter the component"
fi


AMI_ID="ami-0e9fc91dd15aae68b"
SC_ID="sg-09bbbc1d1d1aac5ee"
Instance=t3.micro
COMPONENT=$1




PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID}  --instance-type ${Instance} \
 --security-group-ids ${SC_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"\
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

