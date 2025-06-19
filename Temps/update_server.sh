#!/bin/bash

#script works with having to type in password but it is passed in plain text and is not very secure.
#script not very useful but was an OK first attempt.

# Server Name into Variable
SERVER="ctus-prod-phi-01.pihole"

# SSH command and update commands
ssh -i .ssh/powers_prod -A $SERVER "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean"
echo "Update Complete. ($SERVER)"
sleep 5
