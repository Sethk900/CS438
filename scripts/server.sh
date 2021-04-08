#!/usr/bin/bash
# Seth King
# Dr. Kolias
# CS438 - Semester Project
# 21 February 2021

# This script is intended to be run on the server

while [ 1 -eq 1 ]
do

echo Listening for message...
python3 receivemessage.py 192.168.1.104 80
mv temp.bin message.txt

echo Message received! Message contents:
cat message.txt

echo Enter a reply to Bob:
read message
echo 192.168.1.103 > reply.txt
echo $message >> reply.txt
sendmessage.py reply.txt 192.168.1.103 80

done
