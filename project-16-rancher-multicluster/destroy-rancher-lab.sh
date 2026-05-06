#!/bin/bash

set -e

echo "========== Rancher Lab Cleanup =========="

VPC_ID="vpc-0707f1755d36759b9"
SUBNET_ID="subnet-028cf29c34305339c"
IGW_ID="igw-00a67a475150207f8"
SG_ID="sg-0527216dbf5cc8021"

INSTANCE_IDS=(
"i-018c658de3a1a7a34"
"i-0ed905827044a4918"
"i-065dde99c798354fd"
)

echo "Terminating EC2 instances..."
aws ec2 terminate-instances --instance-ids ${INSTANCE_IDS[@]} >/dev/null

echo "Waiting for instances to terminate..."
aws ec2 wait instance-terminated --instance-ids ${INSTANCE_IDS[@]}

echo "Deleting security group..."
aws ec2 delete-security-group --group-id $SG_ID || true

echo "Detaching Internet Gateway..."
aws ec2 detach-internet-gateway \
  --internet-gateway-id $IGW_ID \
  --vpc-id $VPC_ID || true

echo "Deleting Internet Gateway..."
aws ec2 delete-internet-gateway \
  --internet-gateway-id $IGW_ID || true

echo "Deleting subnet..."
aws ec2 delete-subnet \
  --subnet-id $SUBNET_ID || true

echo "Deleting custom route tables..."

ROUTE_TABLES=$(aws ec2 describe-route-tables \
  --filters Name=vpc-id,Values=$VPC_ID \
  --query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' \
  --output text)

for RT in $ROUTE_TABLES; do
  aws ec2 delete-route-table --route-table-id $RT || true
done

echo "Deleting VPC..."
aws ec2 delete-vpc --vpc-id $VPC_ID || true

echo "Deleting key pair..."
aws ec2 delete-key-pair --key-name rancher-key || true

echo "Cleanup complete!"
