#/bin/bash

vpcid=$(aws ec2 describe-vpcs --filters 'Name=tag:Name1,Values=swe-vpc' --query 'Vpcs[].[VpcId]' --output=text)
echo SWE vpcID is $vpcid

subnetid=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" 'Name=tag:project,Values=swe' --query 'Subnets[].[SubnetId]' --output=text)

echo SWE SubnetIDs are $subnetid

for n in $subnetid
do
numinst=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$n" 'Name=tag:project,Values=swe' --query 'Reservations[].Instances[].InstanceId' --output text --no-paginate)
#echo "Requested instances $numinst"
numprovinst=`aws ec2 describe-instance-status --instance-ids $numinst --query 'length(InstanceStatuses)'`
#echo "numprovinstin $numprovinst"

truecountin=$(( numprovinst + provisioned))
provisioned=$truecountin
#echo "provisioned $provisioned"

#echo "truecountin $truecountin"
done

#echo "truecountout $truecountin"

#numprovinst=`aws ec2 describe-instance-status --instance-ids $numinst --query 'length(InstanceStatuses)'`
numreqinst=`aws ec2 describe-instances --filters "Name=subnet-id,Values=subnet-085178ddbe03c93d5, subnet-020c44367fab8cb9e" --query 'Reservations[*].Instances[*].[InstanceId]' --output=text | wc -l`

##########

        if [ $provisioned = $numreqinst ]; then
                echo "EC2 Instances are created successfully"
                echo Number of EC2 instance Requested $numreqinst provisioned $provisioned
        else
                echo  "One or All of the EC2 instances are NOT created Successfully"
                echo Number of EC2 instance Requested $numreqinst provisioned $provisioned
        exit 1
        fi
exit 0
