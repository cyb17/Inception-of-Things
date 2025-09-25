# Inception-of-Things

This project provides a minimal introduction to Kubernetes and has to be done in a virtual machine. Here, VirtualBox is used.
It consists of setting up multiple environments under specific rules, and the following tools will also be explored: K3s, Vagrant, K3d, and ArgoCD.

## Part 1: Vagrant and k3s
This part consist of setting up 2 virtual machines with Vagrant and install K3s server in the first one, k3s agent in the other one.

How to launch : cd p1 -> vagrant up => 2 VMs created with K3s set up.

Some usefull CLI : 
- vagrant up -> create vm configured in Vagranfile
- vagrant status -> list vms
- vagrant ssh <vm_name> -> connect to the vm with ssh
- vagrant destroy <vm_name> -> destroy vm correctly
- VBoxManage list vms
- VBoxManage controlvm <vm_name> poweroff 
- VBoxManage unregistervm <vm_name> --delete
- sudo systemctl status k3s/k3s-agent -> chek their status

#### Vagrant
- **What is Vagrant ?** : A tool used to automate the process of creating a virtual machine by simply configuring a Vagranfile.
- **Architecture** : ![Vagrant architecture](./img/architecture%20Vagrant.png)
- **Basic Concepts** :

  * **Vagrantfile** : The main configuration file (written in Ruby) that describes the environment: box, resources, networking, provisioning, etc.

  * **Box** : A base image (often a Linux distribution like ubuntu/focal64) used as a template to create a VM.

  * **Provider** : The virtualization software that runs the VM (VirtualBox,VMware, Hyper-V, Docker, etc.).

  * **Provisioning** : A method to automate the installation and configuration of the VM (using shell scripts, Puppet, Chef, etc.).


## Part 2: k3s and 3 simple applications
This part consist of setting up 3 web applications running in the k3s server instance.

How to launch : cd p2 -> vagrant up => k3s server is created and 3 applications are deployed.

### Kubernetes

- **Kubernetes** :  is an open-source platform for automating the deployment, scaling, and management of containerized applications.
	- **Architecture** :
		![Kubernetes Architecture](./img/architecture%20Kubernetes.png)

#### K3s

- **What is K3s ?** : is a lightweight version of Kubernetes, easy to install, suitable for testing and creating multi-node environments
	- **Architecture** :
		![K3s Architecture](./img/architecture%20K3s.svg)


## Part 3: K3d and Argo CD
This part consist of creating a small continuous integration with k3d and ArgoCD

How to launch: cd p3 -> make => Done (for more details cf Makefile).

- **What is K3d ?** : K3d is essentially a K3S instance running inside Docker.
- **What is Argo CD ?** : Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

