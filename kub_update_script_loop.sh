#!/bin/bash

#Looping update script for Microk8s test cluster.

# Define the list of servers
SERVERS=(
    "vmus-tests-k8s-01.server"
    "vmus-test-k8s-02.server"
    "vmus-test-k8s-03.server"
)

# Define the SSH key path (ensure it's the PRIVATE key)
SSH_KEY="~/.ssh/microk8s_test_key" # <-- IMPORTANT: Use the private key

# Define the remote username
REMOTE_USER="levix"

# Define the domain suffix to remove
DOMAIN_SUFFIX=".server"

# Loop through each server
for server in "${SERVERS[@]}"; do
    echo "--- Connecting to $server ---"
    sleep 5

    # Pull the current server name from the loop variable and drop the .server suffix
    # This Bash parameter expansion runs LOCALLY, before SSH
    SHORT_HOSTNAME="${server%$DOMAIN_SUFFIX}"
    #echo "Local short hostname derived from \$server: $SHORT_HOSTNAME"

    # Pass SHORT_HOSTNAME as a variable into your remote commands
    # This allows you to use the derived name for kubectl operations on the remote server
    REMOTE_COMMANDS=$(cat <<EOF
        # We are using the SHORT_HOSTNAME passed from the local script
        # Check that the remote MicroK8s cluster sees the node by this name
        # You might still want to verify with 'microk8s status' if unsure.
        sleep 5

        # Drain a node to upgrade using the SHORT_HOSTNAME
        echo "Draining $SHORT_HOSTNAME..."
        # Might need to add (--delete-emptydir-data) to override Pods with any local storage on a node.
        microk8s kubectl drain "$SHORT_HOSTNAME" --ignore-daemonsets --delete-emptydir-data
        sleep 30

        # Run update commands:
        echo "Running system updates on "
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

        # Check the exit status of the update commands
        if [ \$? -eq 0 ]; then
            echo "Successfully executed update commands."
            # Uncordon node *before* reboot
            echo "Uncordoning $SHORT_HOSTNAME..."
            microk8s kubectl uncordon "$SHORT_HOSTNAME"

            echo "Rebooting $SHORT_HOSTNAME..."
            sleep 5
            sudo reboot
        else
            echo "Failed to execute update commands. Not rebooting."
            microk8s kubectl uncordon "$SHORT_HOSTNAME"
            echo "Node is uncordoned!"
        fi
EOF
)

    # Execute the commands on the remote server
    # -i $SSH_KEY: Specifies the identity file (private key)
    # -t: Forces pseudo-terminal allocation, useful for commands like sudo or microk8s kubectl
    # -o BatchMode=yes: Prevents SSH from asking for passwords
    # -o ConnectTimeout=10: Sets a connection timeout
    ssh -i "$SSH_KEY" -t -o BatchMode=yes -o ConnectTimeout=10 "${REMOTE_USER}@${server}" "$REMOTE_COMMANDS"

    # Check the exit status of the SSH command itself (not the remote commands)
    # This indicates if the SSH connection and remote execution attempt was successful
    if [ $? -eq 0 ]; then
        echo "--- SSH session to $server completed successfully (remote commands initiated) ---"
        #wait a bit for the server to come back up if successful
        echo "Waiting 15 seconds for $server to come back online"
        sleep 15
    else
        echo "--- SSH session to $server failed for $server (or remote commands had issues) ---"
    fi
    echo "" # Add a blank line for readability


    # Wait a few seconds after initiating reboot
    sleep 20
done

echo "#####Script finished#####"