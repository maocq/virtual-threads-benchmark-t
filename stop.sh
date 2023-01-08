#!/bin/bash

StackName=$(jq -r ".StackName" "config.json")


#aws cloudformation describe-stacks --stack-name $StackName
aws cloudformation delete-stack --stack-name $StackName
echo "Deleting..."
aws cloudformation wait stack-delete-complete --stack-name $StackName
echo "Stack removed"

rm -rf sh/.tmp