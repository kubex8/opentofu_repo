#!/usr/bin/env python3

import json
import subprocess
import sys

def get_vm_info():
    """
    Retrieves VM information from the hypervisor using 'virsh' command.
    
    Returns:
        list: A list of dictionaries containing VM details.
    """
    cmd = ['virsh', '-c', 'qemu:///system', 'list', '--all', '--name']
    try:
        # Get the list of VM names
        vm_names = subprocess.check_output(cmd).decode('utf-8').strip().split('\n')
        vms = []

        for vm_name in vm_names:
            if vm_name:
                # Get VM IP addresses using 'virsh domifaddr'
                ip_cmd = ['virsh', '-c', 'qemu:///system', 'domifaddr', vm_name]
                try:
                    ip_output = subprocess.check_output(ip_cmd).decode('utf-8').strip()
                    ip_addresses = []
                    for line in ip_output.splitlines()[2:]:  # Skip headers
                        parts = line.split()
                        if len(parts) >= 4:
                            # Extract IP address and remove netmask if present
                            ip_address = parts[3].split('/')[0]  # Take only the part before the '/'
                            ip_addresses.append(ip_address)

                    vms.append({
                        'name': vm_name,
                        'ip_addresses': ip_addresses
                    })
                except subprocess.CalledProcessError:
                    print(f"Could not retrieve IP for VM: {vm_name}", file=sys.stderr)

        return vms
    except subprocess.CalledProcessError as e:
        print(f"Error running virsh list command: {e}", file=sys.stderr)
        sys.exit(1)

def generate_inventory(vms):
    """
    Generates an Ansible dynamic inventory based on VM information.

    Args:
        vms (list): A list of VM information dictionaries.

    Returns:
        dict: A dictionary representing the Ansible inventory.
    """
    inventory = {
        '_meta': {
            'hostvars': {}
        },
        'all': {
            'children': ['instances']
        },
        'instances': {
            'hosts': []
        }
    }

    for vm in vms:
        for ip_address in vm['ip_addresses']:
            inventory['instances']['hosts'].append(ip_address)
            inventory['_meta']['hostvars'][ip_address] = {
                'ansible_host': ip_address,
                'vm_name': vm['name']
            }

    return inventory

def main():
    """
    Main execution function.
    """
    # Get VM information from the hypervisor
    vms = get_vm_info()
    
    # Generate the Ansible dynamic inventory based on the VM information
    inventory = generate_inventory(vms)
    
    # Print the inventory in JSON format
    print(json.dumps(inventory, indent=2))

# Execute the main function when the script is run
if __name__ == "__main__":
    main()
