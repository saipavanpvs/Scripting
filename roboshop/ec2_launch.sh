#!bin/bash

AMI_ID="ami-0c1d144c8fdd8d690"
SC_ID="sg-09bbbc1d1d1aac5ee"
Instance=t3.micro


aws ec2 run-instances --image-id ${AMI_ID}  --instance-type ${Instance} --security-group-ids ${SC_ID} --tag-specificationS 'ResourceType=instance,Tags=[{key=Name,Value=${COMPONENT}}]'