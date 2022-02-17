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



#echo "Pre-processed rule number $myrulenu"
#for n in $a 
#do
#if [ $n == $myrulenu ]; then
#echo "Random number & rulenumber is equal"
#exit 1
#else
#echo
#echo "mufule number is $myrulenu"
#fi
#done
#echo "This is my rule number $myrulenu"
#exit 0

