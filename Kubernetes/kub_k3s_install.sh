#Step by step instructions to install k3s to a three node rocky linux cluster.
#Follow instructions sequenctially.  

#First, need to modify the firewall of the Linux host as per the documentation:
#It is recommended to turn off firewalld:
sudo systemctl disable firewalld --now

#If you do not want to fully disable you can add these rules instead:
firewall-cmd --permanent --add-port=6443/tcp #apiserver
firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 #pods
firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 #services
firewall-cmd --reload

#Once that is done run this script on the node in which you want to be the main control plane:
curl -sfL https://get.k3s.io | sh -

#Once installed you will not be able to directly interface with the kubectl api with the standard logged in user.
#Either you will have to sudo su - to go into the root user to run commands.  Or you can change the /etc/rancher/k3s/k3s.yaml permissions.
#First chmod the file so root and group can read the file.
sudo chmod 640 /etc/rancher/k3s/k3s.yaml

#Next run 'groups' to get your user group.
#Run the following command to modify the k3s.yaml file to be your users group:
sudo chgrp 'groupName' k3s.yaml
#This will then let your run commands against the kubectl api for your user without sudo su - uses.

#From their, will need to add the other nodes.  Run the following command to get your token:
sudo cat /var/lib/rancher/k3s/server/node-token
#This will get your token from your control plane node to add the other nodes, run:
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN='mynodetoken' sh -

#If you want to add any servers with some specific roles.

#Dedicated etcd Nodes:
curl -fL https://get.k3s.io | sh -s - server --cluster-init --disable-apiserver --disable-controller-manager --disable-scheduler

#Dedicated control-plane Nodes:
curl -fL https://get.k3s.io | sh -s - server --token <token> --disable-etcd --server https://<etcd-only-node>:6443 

