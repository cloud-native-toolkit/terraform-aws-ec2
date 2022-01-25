#/bin/bash
###Validate EC2 instances provisioned thru TF under SWE VPC

vpcid=$(aws ec2 describe-vpcs --filters 'Name=tag:swe,Values=demo' --query 'Vpcs[].[VpcId]' --output=text)
echo SWE vpcID is $vpcid

subnetid=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" 'Name=tag:swe,Values=demo1' --query 'Subnets[].[SubnetId]' --output=text)

echo SWE SubnetIDs are $subnetid

numinst=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$subnetid"  --query 'Reservations[].Instances[].InstanceId' --output text --no-paginate)

numprovinst=`aws ec2 describe-instance-status --instance-ids $numinst --query 'length(InstanceStatuses)'`
numreqinst=`aws ec2 describe-instances --filters "Name=subnet-id,Values=subnet-fdbe309b,subnet-c1ba609b" --query 'Reservations[*].Instances[*].[InstanceId]' --output=text | wc -l`

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
