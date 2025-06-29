#Kubernetes Update Walk-through script
#used for my microk8s cluster
#SSH into each server and run through list of commands in this file
#currently used in a test environment

#SSH to each server in descending order:
ssh -i ~/.ssh/microk8s_test_key.pub levix@10.0.150.210
ssh -i ~/.ssh/microk8s_test_key.pub levix@10.0.150.211
ssh -i ~/.ssh/microk8s_test_key.pub levix@10.0.150.212


#grab host name of server
host=$(hostname)
echo "$host"

#Drain a node to upgrade:
microk8s kubectl drain $host --ignore-daemonsets

#Uncordon node after update/reboot:
microk8s kubectl uncordon $host

#Run update commands:
sudo apt update && sudo apt upgrade -y && sudo apt autoremove

#Reboot the Server
sudo reboot

#Wait 10 Seconds
sleep 15


