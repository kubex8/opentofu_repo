# opentofu_repo

## Steps
1. Create file with ```touch <file>```, and insert configuration structure with ```vi <file>```, save and close vi editor
2. tofu init
3. tofu apply // tofu apply -auto-approve
4. virsh list --all // virsh -c qemu:///system list --all
5. virsh domifaddr ubuntu-vm // virsh -c qemu:///system domifaddr ubuntu-vm
6. curl http://<VM_IP>
