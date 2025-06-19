#!/usr/bin/expect -f

#sudo apt install expect
#interpreter needed to run script. Make Sure its installed before use.

#Script that needs to be distributed to each server.
#control_update_script.sh used to run this local script on server.
#chmod 700 this script to make sure ONLY user can read as password is in script
#"Password" below will need to be changed to your user password.  USE WITH CARE.

#Define the sudo password
set timeout -1
set password "Password"
#Spawn the Bash Shell
spawn bash
#Run the update commands
send "sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt autoclean -y\r"
expect "password for" { send "$password\r" }
#wait for the commands to complete
expect "$ "
#print completed message
send_user "Update Complete.\n"
