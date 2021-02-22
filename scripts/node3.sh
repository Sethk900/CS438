#!/usr/bin/bash
# Seth King
# Dr. Kolias
# CS438 - Semester Project
# 21 February 2021

# This script is intended to be run on the third node in the layer network.

echo Listening for symmetric key...
python3 receivemessage.py 192.168.1.103 80
mv temp.bin node3.enc

echo Symmetric key received. Decrypting symmetric key...
openssl rsautl -decrypt -inkey node3_key_pair.pem -private -in node3.enc > node3.key

echo Symmetric key decrypted. Listening for envelope...
python3 receivemessage.py 192.168.1.103 80
mv temp.bin envelope

echo Envelope received. Decrypting envelope...
openssl aes-128-ecb -e -K $(cat node3.key) -in envelope -out envelope
IP=$(awk '{print $1}' envelope)
awk '{print $2}' envelope > temp
cp temp envelope
rm temp

echo Envelope decrypted. Forwarding message to next layer...
python3 sendmessage.py envelope $IP 80


