# Opentofu project
## Overview
This project provides a setup for creating a Fedora virtual machine using Opentofu and managing it with Ansible. The configuration files and scripts included in this repository allow you to automatically provision a VM and deploy configurations with cloud-init and Ansible playbooks.

## Files Included
1. ansible-inventory.py: A dynamic inventory script for Ansible that retrieves the IP addresses of VMs created with Opentofu. It interacts with the hypervisor using virsh to list running virtual machines and their IP addresses.

2. ansible.cfg: The Ansible configuration file that sets parameters for running playbooks, including the inventory script to be used and SSH connection settings.

3. cloud-init.cfg: A cloud-init configuration file that specifies user setup, SSH key authorization, network configuration, and other initialization commands to be run on the Fedora VM upon boot.

4. main.tf: The Opentofu configuration file that defines the resources to be created, including the virtual machine, associated disks, and network settings. It provisions a Fedora VM and configures it to use cloud-init for initial setup.

5. playbook.yml: An Ansible playbook that executes tasks on the provisioned VM, such as displaying system information.

## Prerequisities
- Opentofu: Ensure you have Opentofu installed on your machine.
- Ansible: Install Ansible for managing configurations.
- Libvirt: Required for managing virtualization with virsh.
- Python 3: Needed to run the ansible-inventory.py script.

## Setup and Usage
### Step 1: Provision the VM with Opentofu
1. Navigate to the directory containing main.tf.
2. Initialize Opentofu:
```
tofu init
```
3. Apply Opentofu configuration to create the VM:
```
tofu apply -auto-approve
```

### Step 2: Configure the Ansible Inventory
1. Ensure the ansible-inventory.py script has execute permissions:
```
chmod +x ansible-inventory.py
```
2. Modify ansible.cfg if necessary to suit your environment.

### Step 3: Execute the Ansible Playbook
1. Run the Ansible playbook to connect to the VM and display system information:
```
ansible-playbook -i ./ansible-inventory.py playbook.yml
```

### Step 4: Review Output
- The output of the Ansible playbook will provide details about the system running on the Fedora VM, confirming successful deployment and configuration.

## Troubleshooting
- Ensure that the VM is running and accessible via SSH.
- If you encounter issues with host key verification, you may need to update your SSH known hosts.
- Check network configurations to ensure the VM can be reached from your host machine.

## Conclusion
This project simplifies the process of provisioning a Fedora VM with Opentofu and managing it with Ansible. The included configuration files and scripts can be customized for various use cases and environments.