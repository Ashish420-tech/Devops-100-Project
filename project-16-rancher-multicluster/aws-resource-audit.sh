#!/bin/bash

echo "========== AWS RESOURCE AUDIT =========="

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "AWS Account ID: $ACCOUNT_ID"
echo

REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

for REGION in $REGIONS; do
    echo "========================================="
    echo "Region: $REGION"
    echo "========================================="

    echo
    echo "EC2 Instances:"
    aws ec2 describe-instances \
        --region $REGION \
        --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType]' \
        --output table 2>/dev/null || true

    echo
    echo "EBS Volumes:"
    aws ec2 describe-volumes \
        --region $REGION \
        --query 'Volumes[*].[VolumeId,Size,State]' \
        --output table 2>/dev/null || true

    echo
    echo "Elastic IPs:"
    aws ec2 describe-addresses \
        --region $REGION \
        --query 'Addresses[*].[PublicIp,AllocationId]' \
        --output table 2>/dev/null || true

    echo
    echo "Load Balancers:"
    aws elbv2 describe-load-balancers \
        --region $REGION \
        --query 'LoadBalancers[*].[LoadBalancerName,State.Code]' \
        --output table 2>/dev/null || true

    echo
    echo "RDS Instances:"
    aws rds describe-db-instances \
        --region $REGION \
        --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus]' \
        --output table 2>/dev/null || true

    echo
    echo "EKS Clusters:"
    aws eks list-clusters \
        --region $REGION \
        --output table 2>/dev/null || true

    echo
    echo "NAT Gateways:"
    aws ec2 describe-nat-gateways \
        --region $REGION \
        --query 'NatGateways[*].[NatGatewayId,State]' \
        --output table 2>/dev/null || true

    echo
    echo "Lambda Functions:"
    aws lambda list-functions \
        --region $REGION \
        --query 'Functions[*].[FunctionName,Runtime]' \
        --output table 2>/dev/null || true

    echo
    echo "S3 Buckets:"
    aws s3 ls 2>/dev/null || true

    echo
done

echo "========== AUDIT COMPLETE =========="
