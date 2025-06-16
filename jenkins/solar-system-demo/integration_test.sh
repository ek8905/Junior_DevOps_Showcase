#!/bin/bash

URL=$(aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.Tags[].Value == "terraform-solsys-web") | .PublicDnsName')
echo "URL data: $URL"

if [[ -n "$URL" ]]; then
 http_code=$(curl -w "%{http_code}" -s  "http://$URL:3000" -o /dev/null)
 if [[ $http_code == '200' ]]; then
     echo "Website is running $http_code"
 else
     echo "Website has problems, the code is: $http_code"
     exit 1
 fi 
else
 echo "URL is missing" 
 exit 1
fi
