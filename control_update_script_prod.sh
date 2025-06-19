#!/bin/bash

#script works in conjunction with remote_update.sh script.
#copy code block for each server.
#SSH keys need to be shared to each server too.

#Define server details
SERVER="ctus-prod-phi-01.pihole"
REMOTE_SCRIPT="./on_server_update_script_prod.sh"
#Set username - Doing LXC Containers first and need root user.
REMOTE_USER="root"

#SSH into server and run remote script
ssh -i ~.ssh/powers_prod $REMOTE_USER@$SERVER "$REMOTE_SCRIPT"
echo "Remote script executed on $SERVER."

