#!/bin/bash

hostname=$1

echo $hostname
# Get token
httpResponse=`http POST api.$hostname/api/AppUsers/login?access_token=EjXFKGnLzeL4AbVfVLXkSXe5eKoZqYEhkvwjzZ2MWaZdTamITPYdKHfslyAMal3t email="admin@webinage.fr" password="75eacfc5"`

echo $httpResponse

token=`echo $httpResponse | sed -E "s/.*\{\"id\":\"([A-Za-z0-9]+)\",.*/\\1/"`
#echo $token

# Load network
echo Loading RBX
httpResponse=`http POST api.$hostname/api/Networks/loadNewNetwork?access_token=$token path="../networks/RBX"`
echo $httpResponse

echo Loading ULI
httpResponse=`http POST api.$hostname/api/Networks/loadNewNetwork?access_token=$token path="../networks/ULI"`
echo $httpResponse

echo Loading VNS
httpResponse=`http POST api.$hostname/api/Networks/loadNewNetwork?access_token=$token path="../networks/VNS"`
echo $httpResponse
