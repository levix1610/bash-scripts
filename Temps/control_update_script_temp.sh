#!/bin/bash

#script works in conjunction with remote_update.sh script.
#copy code block for each server.
#SSH keys need to be shared to each server too.

#Define server details
SERVER="serverName.domain"
REMOTE_SCRIPT="./remote_update.sh"
REMOTE_USER="username"

#SSH into server and run remote script
ssh $REMOTE_USER@$SERVER "$REMOTE_SCRIPT"
echo "Remote script executed on $SERVER."
