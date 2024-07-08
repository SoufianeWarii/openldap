#!/bin/bash

# Read YAML file
YAML_FILE=data.yaml

# READ server
HOST=$(yq --raw-output '.server.host' $YAML_FILE)
PORT=$(yq --raw-output '.server.port' $YAML_FILE)
ADMIN=$(yq --raw-output '.server.admin' $YAML_FILE)
PASSWORD=$(yq --raw-output '.server.password' $YAML_FILE)
echo "Host: $HOST, Port: $PORT, Admin: $ADMIN, Password: $PASSWORD"

# READ applications

# Loop through each application using a quoted string
for application_name in $(yq --raw-output '.applications[].name' data.yaml); do
  echo "Parsing application: $application_name"
  # Filter using single quotes and variable substitution
  owner=$(yq --raw-output '.applications[] | select(.name == "'"$application_name"'" ) .owner' data.yaml)
  location=$(yq --raw-output '.applications[] | select(.name == "'"$application_name"'" ) .location' data.yaml)
  command=$(yq --raw-output '.applications[] | select(.name == "'"$application_name"'" ) .command' data.yaml)
  echo "owner:$owner,location:$location,command:$command"
  #echo "command:$command"
done
