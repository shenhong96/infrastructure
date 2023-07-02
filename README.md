# Infrastructure
Home-lab infrastructure repo to keep tracks of my existing infra state. 
This is a project that automates the deployment and configuration of various services using Ansible and Docker. The services include:

Note: This repo is merely a git backup for codes that coming from gitlab instance that self-hosting in homelab.

## Table of Contents

- [Infrastructure](#infrastructure)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Running the Project](#running-the-project)

## Installation

To install and run this project, follow these steps:

### Prerequisites

- You need to have Ansible installed on your machine. For more information, see [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- You need to have Docker installed on your machine. For more information, see [Docker Installation Guide](https://docs.docker.com/engine/install/).
- You need to have access to the hosts that you want to deploy and configure the services on.

### Running the Project

- Clone this repo to your local machine using `git clone https://github.com/shenhong96/infrastructure.git`.
- Edit the `hosts` file in the root folder of the repo and add the IP addresses or hostnames of your target hosts under the appropriate groups.
- Edit the `group_vars` folder and add any variables that are specific to each group of hosts, such as passwords, domains, ports, etc.
- Edit the `roles` folder and add any tasks that are specific to each role or service, such as templates, files, commands, etc.
- Run `ansible-playbook playbook.yml` to execute the playbook and deploy and configure the services.