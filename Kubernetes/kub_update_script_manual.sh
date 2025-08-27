#Kubernetes Update Walk-through script
#used for my microk8s cluster
#SSH into each server and run through list of commands in this file
#currently used in a test environment

#SSH to each server in descending order:
ssh -i ~/.ssh/microk8s_test_key levix@10.0.100.60
ssh -i ~/.ssh/microk8s_test_key levix@10.0.100.61
ssh -i ~/.ssh/microk8s_test_key levix@10.0.100.62
ssh -i ~/.ssh/microk8s_test_key levix@10.0.100.63
ssh -i ~/.ssh/microk8s_test_key levix@10.0.100.64


# grab host name of server
host=$(hostname)
echo "$host"

# Drain a node to upgrade:
microk8s kubectl drain $host --ignore-daemonsets --delete-emptydir-data

# Run update commands:
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Reboot the Server
sudo reboot

# Uncordon node after update/reboot:
host=$(hostname)
microk8s kubectl uncordon $host



