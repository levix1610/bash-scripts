#!/bin/bash

#script works with having to type in password but it is passed in plain text and is not very secure.
#script not very useful but was an OK first attempt.

# Server Name into Variable
SERVER="ctus-prod-phi-01.pihole"
# User Variable
REMOTE_USER="root"

# SSH command and update pihole server.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "apt update && apt upgrade -y && apt autoremove -y && apt autoclean && pihole -up"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5

#Set server to next.
SERVER="ctus-prod-phi-02.pihole"
# SSH command and update pihole server two.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "apt update && apt upgrade -y && apt autoremove -y && apt autoclean && pihole -up"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5

#Set server to next.
SERVER="cttk-prod-nxt-01.server"
# SSH command and update nextcloud LXC.
# sudo needs to be remove for this container host.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "apt update && apt upgrade -y && apt autoremove -y && apt autoclean"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5


###MOVE TO SERVER VM's###
# User Variable change.
REMOTE_USER="levix"

#Set to docker/portainer server.
SERVER="vmus-prod-ptr-01.server"

# SSH command and update Docker/Portainer server.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5

#Set to Plex Server.
SERVER="vmus-prod-plx-01.server"

# SSH command and update Plex server.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5

#Set to snmp observium server.
SERVER="vmus-prod-obs-01.server"

# SSH command and update observium server.
ssh -i .ssh/powers_prod -A $REMOTE_USER@$SERVER "sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean"

# Check the exit status of the ssh command
if [ $? -eq 0 ]; then
  echo "Update Complete. ($SERVER)"
else
  echo "Update Failed! ($SERVER) - Check for errors above."
fi
sleep 5


echo "##########UPDATE SCRIPT COMPLETED!##########