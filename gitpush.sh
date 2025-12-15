#!/bin/bash

# Check if commit message was provided
if [ -z "$1" ]; then
    echo "Error: No commit message provided."
    echo "Usage: ./gitpush.sh \"your commit message\""
    exit 1
fi

git add .
git commit -m "$1"
git push

