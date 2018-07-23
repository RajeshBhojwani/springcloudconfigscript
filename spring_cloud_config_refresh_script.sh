#!/bin/bash
# This script is to login to PCF and retrieve the Application instance information and hit \refresh endpoint
# This can be used to refresh config server proerties 

# Retrieve guid of the application
guid="$(cf app ${bamboo_app_name} --guid)"

echo "guid is : ${guid}"

# Retrieve total instances of the application
appdata="$(cf app ${bamboo_app_name})"

echo $appdata > tempappdata.txt

cat tempappdata.txt | tr -d " \t\n\r" > trimappdata.txt

instances="$(cat trimappdata.txt | cut -d :  -f 4 | cut -d / -f 1)"

echo "No of instances are : ${instances}"

#Build url
strref="/refresh"
url=$bamboo_app_url$strref

headername="X-CF-APP-INSTANCE:"
guid="${guid}:"

# Run loop to hit /refresh endpoint for each instance.
instance=0
while [ $instance -lt $instances ]
 do
    echo "instance : ${instance}"
    curl -X POST $url -H $headername$guid$instance
      ((instance++))
 done


echo "refresh completed"