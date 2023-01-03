#!/bin/bash
source ./sh/functions.sh

STACK_NAME="test-stack-ab"

UrlReposity=$(jq -r ".UrlReposity" "config.json")
VpcId=$(jq -r ".VpcId" "config.json")
SubnetId=$(jq -r ".SubnetId" "config.json")
InstanceType=$(jq -r ".InstanceType" "config.json")
ImageId=$(jq -r ".ImageId" "config.json")
User=$(jq -r ".User" "config.json")
KeyName=$(jq -r ".KeyName" "config.json")
Key=$(jq -r ".Key" "config.json")

p_ip=$(dig @resolver4.opendns.com myip.opendns.com +short -4)
MyIp=$(echo "$p_ip/24")
CidrSubnet=$(aws ec2 describe-subnets --subnet-ids $SubnetId | jq -r '.Subnets[].CidrBlock')

echo "My public IP $MyIp"

## Infraestructura

aws cloudformation deploy \
    --stack-name $STACK_NAME \
    --template-file ./infrastructure.yml \
    --region us-east-1 \
    --parameter-overrides UrlReposity="$UrlReposity" MyIp="$MyIp" CidrSubnet="$CidrSubnet" VpcId="$VpcId" SubnetId="$SubnetId" \
        InstanceType="$InstanceType" ImageId="$ImageId" User="$User" KeyName="$KeyName"


outputs=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq '{Outputs: .Stacks[].Outputs}')

app_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PublicIPApp") | .OutputValue')
app_private_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PrivateIPApp") | .OutputValue')
latency_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PublicIPLatency") | .OutputValue')
latency_private_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PrivateIPLatency") | .OutputValue')
db_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PublicIPDB") | .OutputValue')
db_private_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PrivateIPDB") | .OutputValue')

## DB
wait_initialized $db_ip $User $Key
start_docker_image $db_ip $UrlReposity "db" $User $Key

## Latency
wait_initialized $latency_ip $User $Key
start_docker_image $latency_ip $UrlReposity "node" $User $Key


echo "\n\n App"
echo "ssh -o \"StrictHostKeyChecking no\" -i "$Key" $User@$app_ip" > /dev/tty
echo "http://$app_ip:8080"
