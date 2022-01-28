#/bin/bash
###Validate EC2 instances provisioned thru TF under SWE VPC

REGION=$(cat terraform.tfvars | grep -E "^region" | sed "s/region=//g" | sed 's/"//g')

aws configure set region ${REGION}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}

vpcid=$(aws ec2 describe-vpcs --filters 'Name=tag:Name,Values=swe-vpc' --query 'Vpcs[].[VpcId]' --output=text)
echo SWE vpcID is $vpcid

subnetid=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" 'Name=tag:project,Values=swe' --query 'Subnets[].[SubnetId]' --output=text)

echo SWE SubnetIDs are $subnetid

numinst=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=subnet-06d0a8066ed3e64d1,subnet-0a350449103177c71" 'Name=tag:project,Values=swe' --query 'Reservations[].Instances[].InstanceId' --output text --no-paginate)

numprovinst=`aws ec2 describe-instance-status --instance-ids $numinst --query 'length(InstanceStatuses)'`
numreqinst=`aws ec2 describe-instances --filters "Name=subnet-id,Values=subnet-06d0a8066ed3e64d1,subnet-0a350449103177c71" --query 'Reservations[*].Instances[*].[InstanceId]' --output=text | wc -l`

##########

        if [ $numprovinst = $numreqinst ]; then
                echo "EC2 Instances are created successfully"
                echo Number of EC2 instance Requested $numreqinst provisioned $numprovinst
        else
                echo  "One or All of the EC2 instances are NOT created Successfully"
                echo Number of EC2 instance Requested $numreqinst provisioned $numprovinst
        exit 1
        fi
exit 0
