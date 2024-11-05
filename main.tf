terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.6.12"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "fedora-qcow2" {
  name   = "fedora-disk"
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "cloudinit.iso"
  user_data      = file("${path.module}/cloud_init.cfg")
  pool           = "default"
}

resource "libvirt_domain" "fedora_vm" {
  name   = "fedora-vm"
  memory = 2048
  vcpu   = 2

  # Disk konfigurace pro VM
  disk {
    volume_id = libvirt_volume.fedora-qcow2.id
  }

  # Nastavení sítě pro VM s pevně zadanou IP adresou
  network_interface {
    network_name = "default"
    addresses = ["192.168.122.10"]  # Použijte požadovanou IP adresu
  }

  # Připojení cloud-init disku
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # Volitelné nastavení konzole a grafiky
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
  }
}
