#!/bin/bash

STACK_NAME="test-stack-ab"

#aws cloudformation describe-stacks --stack-name $STACK_NAME
aws cloudformation delete-stack --stack-name $STACK_NAME
echo "Deleting..."
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME
echo "Stack removed"