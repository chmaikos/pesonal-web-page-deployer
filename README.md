# Personal Web Page Deployer

Welcome to the Personal Web Page Deployer repository. This project facilitates the streamlined deployment of personal web pages using a variety of modern technologies including Ansible, Docker, Kubernetes, and Terraform. Below, you will find a detailed breakdown of each module and guidelines on how to use them to their fullest potential.

## Table of Contents

- [Personal Web Page Deployer](#personal-web-page-deployer)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
    - [Installations](#installations)
      - [Ansible](#ansible)
      - [Docker and Docker Compose](#docker-and-docker-compose)
      - [Kubectl and Terraform](#kubectl-and-terraform)
    - [Account Setups](#account-setups)
      - [Hetzner Cloud Account](#hetzner-cloud-account)
      - [Cloudflare Account](#cloudflare-account)
    - [SSH Key Generation](#ssh-key-generation)
  - [How to use the modules](#how-to-use-the-modules)
  - [Ansible](#ansible-1)
    - [Environment Variables](#environment-variables)
    - [Usage](#usage)
  - [Docker](#docker)
    - [Environment Variables](#environment-variables-1)
    - [Usage](#usage-1)
  - [Kubernetes](#kubernetes)
    - [Environment Variables](#environment-variables-2)
    - [Usage](#usage-2)
  - [Terraform](#terraform)
    - [hcloud\_docker\_vm](#hcloud_docker_vm)
    - [hcloud\_npm\_vm](#hcloud_npm_vm)
    - [Environment Variables](#environment-variables-3)
    - [Usage](#usage-3)
  - [Contribution](#contribution)
  - [License](#license)

## Prerequisites

Before you begin, ensure you have met the following prerequisites:

### Installations

#### Ansible

Install Ansible on your system using the following command:

```bash
apt-add-repository --yes --update ppa:ansible/ansible
apt-get update
apt-get install -y ansible
```

#### Docker and Docker Compose

Install Docker and Docker Compose using the following commands:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Start and enable Docker service
systemctl start docker
systemctl enable docker
```

#### Kubectl and Terraform

For Kubectl and Terraform as well as Packer and Hcloud we find that the best way to install them is with brew

First install brew based on the [Documentation](https://docs.brew.sh/Installation)

```bash
brew install terraform 
brew install hcloud 
brew install kubectl 
brew install packer
```

### Account Setups

#### Hetzner Cloud Account

Create an account on [Hetzner Cloud](https://www.hetzner.com/cloud) and generate an API token from the "Security" section in your cloud project settings.

#### Cloudflare Account

Set up an account on [Cloudflare](https://www.cloudflare.com/) to manage your domain's DNS settings. Obtain your API token and Zone ID from the Cloudflare dashboard.

### SSH Key Generation

Generate an SSH key pair to securely access your server using the following command:

```bash
ssh-keygen -t rsa -b 2048
```

Keep the SSH key in a secure place as it will be needed for server authentication.

## How to use the modules

## Ansible

The Ansible module leverages automation to simplify the deployment process, ensuring a hassle-free setup with minimized errors. Here are the pivotal files and their functionalities:

- **.env.j2**: This is a Jinja2 template file that helps in setting up environment variables required during the deployment phase. It is essential to tailor this file to match your specific settings before initiating the Ansible playbooks.

### Environment Variables

- `NODE_ENV`: Defines the environment in which the application is running (default: 'development').
- `PORT`: Specifies the port the application will run on (default: 3000).
- `EXPOSED_PORT`: The port exposed by the Docker container (default: 3000).
- `TOKEN_SECRET`: Secret key for encoding tokens (default: 'default_secret').
- `DB_CONN_STRING`: The MongoDB connection string (default: 'mongodb://localhost:27017/mydatabase').
- `DB_NAME`: Name of the database (default: 'mydatabase').
- `SMTP_HOST`: SMTP server host (default: 'localhost').
- `SMTP_PORT`: SMTP server port (default: 25).
- `SMTP_USERNAME`: SMTP server username (default: '').
- `SMTP_PASSWORD`: SMTP server password (default: '').
- `SMTP_SENDER`: Email address used to send emails (default: 'no-reply@mydomain.com').
- `BACKEND`: Backend API base URL (default: 'http://localhost:3000').
- `FRONTEND`: Frontend base URL (default: 'http://localhost:8080').
- `MY_EMAIL`: Your email address (default: 'admin@mydomain.com').

### Usage

1. Begin by customizing the `.env.j2` file with your environment variables to suit your deployment needs.
2. Configure your inventory appropriately in the `inventory.yml` file to outline the servers where the deployment will take place.
3. Execute the playbook of your choice using the command:
   - For a bare environment: `ansible-playbook -i inventory.yml deploy_bare.yml`
   - For a Docker environment: `ansible-playbook -i inventory.yml deploy_docker.yml`

## Docker

The Docker module houses configurations essential for establishing your personal web page in a Docker environment. The key files in this module are:

- **.env.example**: An illustrative file delineating the environment variables necessary for Docker configurations. It is recommended to rename it to `.env` and modify it to mirror your specific settings.

### Environment Variables

See [Ansible](#ansible)

### Usage

1. Rename `.env.example` to `.env` and populate it with your environment variables to tailor the Docker setup to your needs.
2. Launch the Docker Compose file using the command: `docker-compose -f docker-compose.prod.yml up -d` to initiate the deployment in a production environment.

## Kubernetes

This module empowers you to deploy your personal web page in a Kubernetes cluster, utilizing the configurations provided herein. The central files in this module include:

- **app-stack.yaml**: A comprehensive Kubernetes manifest file that delineates the necessary resources for your application stack, including deployments, services, and ingress controllers, fostering a robust application setup.
- **config-plain.yaml**: This configuration file facilitates the setup of a ConfigMap resource in your Kubernetes cluster, aiding in the streamlined management of your application's configuration.
- **secret.yaml**: A Kubernetes secret file that helps in managing sensitive information such as passwords and API keys, enhancing the security posture of your application.

### Environment Variables

- `SMTP_PASSWORD`: The SMTP server password encoded in base64 format.

### Usage

1. Customize the Kubernetes manifest files to align with your specific settings, ensuring a tailored deployment process.
2. Implement the configurations using the commands:
   - `kubectl apply -f config-plain.yaml` to set up the ConfigMap resource.
   - `kubectl apply -f secret.yaml` to establish the secret resource.
   - `kubectl apply -f app-stack.yaml` to establish the necessary Kubernetes resources for your application.

## Terraform

The Terraform module encompasses scripts and configurations pivotal in provisioning infrastructure in the Hetzner Cloud. It bifurcates into two sub-modules: `hcloud_docker_vm` and `hcloud_npm_vm`, each housing key files detailed below:

### hcloud_docker_vm

- **install.sh**: A script curated to install the requisite dependencies on your Hetzner Cloud VM, paving the way for a smooth deployment process.
- **main.tf**: The principal Terraform configuration file that outlines the infrastructure to be provisioned, serving as the blueprint for your deployment setup.
- **terraform.tfvars.example**: This example file guides you in setting up your Terraform variables. It is advisable to rename it to `terraform.tfvars` and modify it to reflect your specific settings.

### hcloud_npm_vm

- **install.sh**: This script facilitates the installation of necessary dependencies on your Hetzner Cloud VM, setting the stage for a successful deployment.
- **main.tf**: The main Terraform configuration file in this sub-module defines the infrastructure to be provisioned, acting as the roadmap for your deployment strategy.
- **terraform.tfvars.example**: An example file to assist you in configuring your Terraform variables. Rename it to `terraform.tfvars` and personalize it to suit your deployment needs.

### Environment Variables

- `hcloud_token`: Your Hetzner Cloud API token.
- `ssh_key_path`: The path to your SSH key (default: '~/.ssh/id_rsa.pub').
- `domain_name`: Your domain name.
- `cloudflare_api_token`: Your Cloudflare API token.
- `cloudflare_zone_id`: Your Cloudflare Zone ID.

### Usage

1. Navigate to the sub-module of your choice (`hcloud_docker_vm` or `hcloud_npm_vm`) and rename `terraform.tfvars.example` to `terraform.tfvars`, inputting your Terraform variables to personalize your infrastructure setup.
2. Initialize your Terraform configuration with the command: `terraform init` to prepare the Terraform working directory.
3. Apply the Terraform configuration using the command: `terraform apply` to initiate the provisioning of your infrastructure as per the defined configurations.

## Contribution

We warmly welcome contributions to this project. Feel free to open issues or submit pull requests to enhance the repository further.

## License

(Provide details on the license under which this project is distributed)
