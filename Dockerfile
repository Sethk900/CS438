# A rough draft dockerfile for our semester project container

# Set the base image
FROM ubuntu

# Set the working directory within the container
WORKDIR /code

# Copy any the txt file that lists all of the python modules we'll need to run the scripts
COPY requirements.txt .

# Run updates and install pip
RUN apt-get update
RUN apt-get install -y python3-pip

# Copy the content of the scripts directory into our container
COPY scripts/ .


