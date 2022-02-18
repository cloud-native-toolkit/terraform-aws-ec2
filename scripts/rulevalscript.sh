#!/bin/bash 

a=`aws ec2 describe-network-acls --output text --query 'NetworkAcls[].Entries[].[RuleNumber]'`
myrulenu=$(( $RANDOM % 750 + 150))

for n in $a
do
while [ $n -ne $myrulenu ]
do
echo "My Rule number is $myrulenu"
echo "$myrulenu" > rule.txt
exit
done
done

