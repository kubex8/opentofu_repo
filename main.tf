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

resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-disk"
  pool   = "default"
  source = "https://cloud-images.ubuntu.com/minimal/releases/focal/release/ubuntu-20.04-minimal-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "cloudinit.iso"
  user_data      = "${file("${path.module}/cloud_init.cfg")}"
  pool           = "default"
}

resource "libvirt_domain" "ubuntu_vm" {
  name   = "ubuntu-vm"
  memory = "1024"
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id
}

