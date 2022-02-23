#/bin/bash
SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
echo "SCRIPT_DIR: ${SCRIPT_DIR}"
#vpcid=$(aws ec2 describe-vpcs --filters 'Name=tag:project,Values=swe' --query 'Vpcs[].[VpcId]' --output=text)



export vpcid=$(terraform output -json | jq -r '."vpc_id".value')
REGION=$(cat terraform.tfvars | grep -E "^region" | sed "s/region=//g" | sed 's/"//g')

echo "VPC_ID: ${vpcid}"
echo "REGION: ${REGION}"

aws configure set region ${REGION}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}


echo SWE vpcID is $vpcid

#subnetid=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid" 'Name=tag:project,Values=swe' --query 'Subnets[].[SubnetId]' --output=text)

subnetid=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcid"  --query 'Subnets[].[SubnetId]' --output=text)

echo SWE SubnetIDs are $subnetid

for n in $subnetid
do
numinst=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$n" 'Name=tag:project,Values=swe' --query 'Reservations[].Instances[].InstanceId' --output text --no-paginate)
numprovinst=`aws ec2 describe-instance-status --instance-ids $numinst --query 'length(InstanceStatuses)'`
truecountin=$(( numprovinst + provisioned))
provisioned=$truecountin
done
#echo "Provisioned EC2 Instances  $provisioned"

for m in $subnetid
do 
numreqinst=`aws ec2 describe-instances --filters "Name=subnet-id,Values=$m" --query 'Reservations[*].Instances[*].[InstanceId]' --output=text | wc -l`
reqinstcount=$(( numreqinst + requestedinst))
requestedinst=$reqinstcount
done
#echo "Requested Instances $requestedinst"

##########

        if [ $provisioned = $requestedinst ]; then
                echo "EC2 Instances are created successfully"
                echo Number of EC2 instance Requested $requestedinst provisioned $provisioned
        else
                echo  "One or All of the EC2 instances are NOT created Successfully"
                echo Number of EC2 instance Requested $requestedinst provisioned $provisioned
        exit 1
        fi
exit 0
