resource "proxmox_vm_qemu" "dominator" {
  target_node   = "proxmox"
  name          = "Dominator"
  iso           = "zfs-data_mp:iso/pop-os_22.04_amd64_nvidia_11.iso"
  password      = var.lxc_password
  vmid          = 401
  cores         = 6
  sockets       = 1
  memory        = 12288
  balloon       = 6144
  os_type       = "ubuntu"
  agent         = 1
  oncreate      = 1

  vga {
      type      = none
  }

  network {
      model     = virtio
      bridge    = vmbr0

  }

  disk {
    // This disk will become scsi0
    type        = "virtio"
    storage     = "zfs-data_mp"
    size        = "50G"
    format      = "qcow2"
    ssd         = 1
    media       = "disk"
  }

  disk {
    // This disk will become scsi0
    type        = "virtio"
    storage     = "zfs-data_mp"
    size        = "80G"
    format      = "qcow2"
    ssd         = 1
    media       = "disk"
  }
  
}


