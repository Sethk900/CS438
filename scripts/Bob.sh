#!/usr/bin/bash
# Seth King
# Dr. Kolias
# CS438 - Semester Project
# 21 February 2021

# This script is intended to be run on Bob's machine.
# Bob is the host in our network topology who is trying to access a server anonymously through a layer network.
# To execute: ./Bob.sh

# To do:
#	- Modify receivemessage.py so that it stops executing after receiving a message

echo "Entering infinite loop. Use a keyboard interrupt (Ctrl + C) to stop the script."

while [ 1 -eq 1 ]
do

echo Enter a message to send to the server:
read message

echo Generating symmetric keys...
openssl rand -hex -out node1.key 16
openssl rand -hex -out node2.key 16
openssl rand -hex -out node3.key 16

echo Encrypting symmetric keys with nodes public keys...
rsautl -encrypt -inkey node1_public.pem -pubin -in node1.key -out node1.enc
rsautl -encrypt -inkey node2_public.pem -pubin -in node2.key -out node2.enc
rsautl -encrypt -inkey node3_public.pem -pubin -in node3.key -out node3.enc

echo Sending symmetric keys to nodes...
python3 sendmessage.py node1.enc 192.168.1.101 80
python3 sendmessage.py node2.enc 192.168.1.102 80
python3 sendmessage.py node3.enc 192.168.1.103 80

echo Packing the envelope...
echo "192.168.1.104" > envelope
echo $message >> envelope
openssl aes-128-ecb -e -K $(cat node3.key) -in envelope -out envelope
echo "192.168.1.103" > temp
cat envelope >> temp
cp temp envelope
openssl aes-128-ecb -e -K $(cat node2.key) -in envelope -out envelope
echo "192.168.1.102" > temp
cat envelope >> temp
cp temp envelope
openssl aes-128-ecb -e -K $(cat node1.key) -in envelope -out envelope

echo Sending the envelope...
python3 sendmessage.py envelope 192.168.1.101 80

python3 receivemessage.py 192.168.1.105 80
mv temp.bin serverResponse.enc
echo Response received. Unpacking the envelope...
openssl aes-128-ecb -d -K $(cat node1.key) -in serverResponse.enc -out envelope
IP=$(awk '{print $1}' envelope)
awk '{print $2}' envelope > temp
cp temp envelope
rm temp
openssl aes-128-ecb -d -K $(cat node2.key) -in envelope -out envelope
IP=$(awk '{print $1}' envelope)
awk '{print $2}' envelope > temp
cp temp envelope
rm temp
openssl aes-128-ecb -d -K $(cat node3.key) -in envelope -out envelope
IP=$(awk '{print $1}' envelope)
awk '{print $2}' envelope > temp
cp temp envelope
rm temp

echo Response decrypted. The server said:
cat envelope

done
