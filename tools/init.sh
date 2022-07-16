#!/bin/bash

# utilities

# courtesy: https://stackoverflow.com/a/14203146/10302179
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--name)
      PROJECT_NAME="$2"
      REPO_NAME=$(echo $PROJECT_NAME | tr " " "-" | tr '[:upper:]' '[:lower:]')
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

# init a new project
# args: --name # project name in natural case with spaces. dev references to project will remove spaces and make lowercase
# Create a github repo for the project
gh repo create $REPO_NAME -c --private
