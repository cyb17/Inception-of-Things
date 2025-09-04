# Inception-of-Things

This project is a minimal introduction to Kubernetes and it consist of setting up several environments under specific rules.

## Part 1: K3s and Vagrant
This part consist of setting up 2 virtual machines with Vagrant and install K3s server in the first one, k3s agent in the other one. 

#### Vagrant
- **What is Vagrant ?** : A tool used to automate the process of creating a virtual machine by simply configuring a Vagranfile.
- **Architecture** : ![Vagrant architecture](./img/architecture%20Vagrant.png)
- **Basic Concepts** :

  * **Vagrantfile** : The main configuration file (written in Ruby) that describes the environment: box, resources, networking, provisioning, etc.

  * **Box** : A base image (often a Linux distribution like ubuntu/focal64) used as a template to create a VM.

  * **Provider** : The virtualization software that runs the VM (VirtualBox,VMware, Hyper-V, Docker, etc.).

  * **Provisioning** : A method to automate the installation and configuration of the VM (using shell scripts, Puppet, Chef, etc.).

#### K3s

- **What is K3s ?** : is a lightweight version of Kubernetes, easy to install, suitable for testing and creating multi-node environments
	- **Architecture** :
		![K3s Architecture](./img/architecture%20K3s.svg)

- **Kubernetes** :  is an open-source platform for automating the deployment, scaling, and management of containerized applications.
	- **Architecture** :
		![Kubernetes Architecture](./img/architecture%20Kubernetes.png)

## Part 2: K3s and three simple applications
This part consist of setting up 3 web applications running in the k3s server instance

## Part 3: K3d and Argo CD
