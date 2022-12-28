#!/bin/bash

rds_password=$(aws secretsmanager get-secret-value --secret-id rds_key --region us-east-1 | jq .SecretString | cut -d ':' -f 2 | tr -d '\\' | tr -d '"' | tr -d '}')
ec2one=$(cd ../tf && terraform output -json | jq -r .instance_public_ip1.value)
ec2two=$(cd ../tf && terraform output -json | jq -r .instance_public_ip2.value)
rds_endpoint=$(terraform output -json | jq -r .rds_endpoint.value | cut -d ':' -f 1)



echo $ec2one >> ../ansible/inventory/hosts
echo $ec2two >> ../ansible/inventory/hosts
sed -i "s/rds_host/$rds_endpoint/g" ../ansible/roles/wordpress/defaults/main.yml
sed -i "s/rds_db_password/$rds_password/g" ../ansible/roles/wordpress/defaults/main.yml