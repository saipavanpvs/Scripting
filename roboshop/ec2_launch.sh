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

create_ec2() {

 echo -e "****** Creating \e[35m ${COMPONENT} \e[0m Server Is In Progress ************** "
 PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID}  --instance-type ${Instance} \
 --security-group-ids ${SC_ID} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"\
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
 echo -e "Private IP Address of the $COMPONENT is $PRIVATEIP \n\n"
 echo -e "Creating DNS Record of ${COMPONENT}: "

 sed -e "s/COMPONENT/${COMPONENT}/"  -e "s/IPADDRESS/${PRIVATE_IP}/" route53.json  > /tmp/r53.json
 aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/r53.json
 echo -e "\e[36m **** Creating DNS Record for the $COMPONENT has completed **** \e[0m \n\n"

 }
 if [ "$1" == "all" ]; then 

    for component in mongodb catalogue cart user shipping frontend payment mysql redis rabbitmg; do 
        COMPONENT=$COMPONENT 
        create_ec2
    done 

else 
        create_ec2 
fi 





