#!bin/bash

COMPONENT=$1
if [ -z $1 ]  ; then 
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \t \t"
    echo -e "\e[35m Ex Usage \e[0m \n\t\t $ bash launch_ec2.sh shipping"
    exit 1
fi 


AMI_ID="ami-0e9fc91dd15aae68b"
SC_ID="sg-09bbbc1d1d1aac5ee"
Instance=t3.micro





PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID}  --instance-type ${Instance} \
 --security-group-ids ${SC_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"\
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

