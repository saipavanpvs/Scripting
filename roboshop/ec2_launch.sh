#!bin/bash

COMPONENT=$1
if [ -z $1 ]  ; then 
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m \n \t \t"
    echo -e "\e[35m Ex Usage \e[0m \n\t\t $ bash launch_ec2.sh shipping"
    exit 1
fi 


AMI_ID="$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup"| jq '.Images[].ImageId'|sed -e 's/"//g')
SC_ID="$(aws ec2 describe-security-groups  --filters Name=group-name,Values=b55-allow-all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"       # b54-allow-all security group id

Instance=t3.micro





PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID}  --instance-type ${Instance} \
 --security-group-ids ${SC_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"\
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
echo ${PRIVATE_IP}




