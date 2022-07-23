#!/bin/bash

# globals
SCRIPT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# utilities

# courtesy: https://stackoverflow.com/a/14203146/10302179
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "-h | --help: This help menu"
      echo "-n | --name: (Required) The name of your project. Must be less than 21 characters with letters, numbers, and hyphens (Firebase's requirements)"
      exit 0
      ;;
    -n|--name)
      PROJECT_NAME=`echo "$2" | sed -e 's/^[[:space:]]*//'` # trim the name
      REPO_NAME=$(echo $PROJECT_NAME | tr " " "-" | tr '[:upper:]' '[:lower:]')
      GCLOUD_PROJECT_NAME=$PROJECT_NAME
      RANDOM_STRING=$(openssl rand -base64 29 | tr -d "=+/" | cut -c1-8)
      # Req's for Firebase Project id https://cloud.google.com/resource-manager/docs/creating-managing-projects
      GCLOUD_PROJECT_ID=$(echo "$REPO_NAME-$RANDOM_STRING" | tr "[:upper:]" "[:lower:]")
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 5
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

if [ -z "$GCLOUD_PROJECT_NAME" ]
then
      echo "Please pass in a name with the -n somename"
      echo "--help for help"
      exit 5
fi

# init a new project
# args: --name # project name in natural case with spaces. dev references to project will remove spaces and make lowercase
# Create a github repo for the project
gh repo create $REPO_NAME -c --private
# Setup Firebase
gcloud auth login # Triggers a browser login
FIREBASE_TOKEN=$(firebase login:ci | grep '1//' | cat | sed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g")
echo $SCRIPT_PATH/firebase.exp "$FIREBASE_TOKEN" "$GCLOUD_PROJECT_NAME" "$GCLOUD_PROJECT_ID"
expect $SCRIPT_PATH/firebase.exp "$FIREBASE_TOKEN" "$GCLOUD_PROJECT_NAME" "$GCLOUD_PROJECT_ID"
#firebase init --token $FIREBASE_TOKEN hosting # Works but goes into interactive mode
#gcloud projects create $GCLOUD_PROJECT_ID --name=$GCLOUD_PROJECT_NAME

exit 0
