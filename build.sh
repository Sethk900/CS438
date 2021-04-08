#!/usr/bin/bash
# A script that will eventually be used to build and push the Docker container to the GNS3 server
# Currently we don't have credentials, so this is incomplete

sudo systemctl start docker
sudo docker build . -t layer_network_node
docker push <insert credentials, image ID>
