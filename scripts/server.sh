#!/usr/bin/bash
# Seth King
# Dr. Kolias
# CS438 - Semester Project
# 21 February 2021

# This script is intended to be run on the server

echo Listening for message...
python3 receivemessage.py 192.168.1.104 80
mv temp.bin message.txt

echo Message received! Message contents:
cat message.txt

echo "Message received: " > reply.txt
cat message.txt >> reply.txt
sendmessage.py reply.txt 192.168.1.103 80

