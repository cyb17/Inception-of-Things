# Inception-of-Things

This project is a minimal introduction to Kubernetes and it consist of setting up several environments under specific rules.

## Part 1: K3s and Vagrant
This part consist of setting up 2 virtual machines with Vagrant and install K3s server in the first one, k3s agent in the other one. 

- **What is Vagrant ?** : A tool used to automate the process of creating a virtual machine by simply configuring a Vagranfile.

- **Vagrant Basic Concepts** :

  * **Vagrantfile** : The main configuration file (written in Ruby) that describes the environment: box, resources, networking, provisioning, etc.

  * **Box** : A base image (often a Linux distribution like ubuntu/focal64) used as a template to create a VM.

  * **Provider** : The virtualization software that runs the VM (VirtualBox,VMware, Hyper-V, Docker, etc.).

  * **Provisioning** : A method to automate the installation and configuration of the VM (using shell scripts, Puppet, Chef, etc.).

  * **Port forwarding** : Redirects a port from the VM to the host (example: host:8080 → guest:80).

  * **Private network** : Assigns a private IP address to the VM, accessible only from the host machine.

  * **Synced folder** : A shared folder between the host and the VM (by default, the Vagrant project folder is mounted at /vagrant).

- **Kubernetes** :  is an open-source platform for automating the deployment, scaling, and management of containerized applications.

- **K3s** : is a lightweight version of Kubernetes, easy to install, suitable for testing and creating multi-node environments

## Part 2: K3s and three simple applications
This part consist of setting up 3 web applications running in the k3s server instance

## Part 3: K3d and Argo CD
