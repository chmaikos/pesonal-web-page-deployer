#!/bin/bash
# Update package lists
apt-get update

# Install prerequisites
apt-get install -y software-properties-common

# Add Ansible PPA and Install Ansible
apt-add-repository --yes --update ppa:ansible/ansible
apt-get update
apt-get install -y ansible

# Install Node.js
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

# Install mongodb 
MONGO_VERSION=6.0
sudo apt-get update
sudo apt-get install gnupg -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc | sudo gpg --dearmor -o /etc/apt/keyrings/mongodb-${MONGO_VERSION}.gpg
cd /etc/apt/sources.list.d/
sudo touch mongodb-org-${MONGO_VERSION}.list
echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb-${MONGO_VERSION}.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/${MONGO_VERSION} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod

# Update repositories
sudo apt-get update

# Install NGINX
sudo apt-get install nginx certbot -y

# Configure firewall
sudo ufw allow 'Nginx Full' # both ports 80 and 443

# Uncomment to disable default virtual host
unlink /etc/nginx/sites-enabled/default


### SSH Configuration ###
# Get SSH keys from script arguments
SSH_PUBLIC_KEY_CONTENT="$1"
SSH_PRIVATE_KEY_CONTENT="$2"

# Create SSH directory and set permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Write SSH keys to files
echo -e "$SSH_PUBLIC_KEY_CONTENT" > ~/.ssh/id_rsa.pub
echo -e "$SSH_PRIVATE_KEY_CONTENT" > ~/.ssh/id_rsa

# Set permissions for SSH keys
chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa

# Start the SSH agent and add the key
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
