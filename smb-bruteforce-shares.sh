#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file_path> <IP>"
  exit 1
fi

# Define the file to read from the command line argument
file="$1"
IP="$2"

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "File '$file' not found!"
  exit 1
fi

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'  # No Color

# Loop through each line of the file
while IFS= read -r line
do
  # Run smbclient and discard errors; make sure it does not interact with the terminal
  smbclient "//$IP/$line" -N -c "exit" &>/dev/null

  # Check if smbclient was successful (exit code 0 means success)
  if [ $? -eq 0 ]; then
    # If successful, print Success in green
    echo -e "[${GREEN}Success${NC}] $line"
  else
    # If failed, print Failed in red
    echo -e "[${RED}Failed${NC}] $line"
  fi
done < "$file"
