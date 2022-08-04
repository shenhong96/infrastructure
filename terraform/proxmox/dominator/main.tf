#### WORK IN PROGRESS ####
resource "proxmox_vm_qemu" "dominator" {
  target_node   = "proxmox"
  name          = "Dominator"
  iso           = "zfs-data_mp:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password      = var.lxc_password
  vmid          = 401
  cores         = 6
  sockets       = 1
  memory        = 12288
  balloon       = 6144
  os_type       = ubuntu

  vga {
      type      = none
  }

  network {
      model     = virtio
      bridge    = vmbr0

  }

  disk {
    // This disk will become scsi0
    type        = "scsi"
    storage     = "zfs-data_mp"
    size        = "150G"
    format      = "qcow2"
    ssd         = 1
    media       = "disk"
  }

  




  unprivileged = true
  cores        = 2
  memory       = 4096

  start        = true
  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsYRkCx0uNh2qxXw5MX0xHTk25puTJgbORwnz/xtqpw mba-m1@MBA-M1s-MacBook-Air.local
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKt+18o7jPac6M5BESRXx2B1pDZ3YlqxeWWrojCvi0Ky root@Ansible
  EOT
  #vmid         = 116
  // Terraform will crash without rootfs defined
  rootfs {
    storage = "zfs-data_mp"
    size    = "20G"
  }

#  mountpoint {
#    slot    = 0
#    storage = "/mnt/storage/appdata/gitlab"
#    mp      = "/mnt/appdata"
#    size    = "1G"
#  }
  mountpoint {
    key     = "1"
    slot    = 1
    storage = "/mnt/storage/appdata/gitlab"
    volume  = "/mnt/storage/appdata/gitlab"
    mp      = "/mnt/appdata"
    size    = "2G"
  }

  features {
    nesting = true
   #fuse = 
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.9.159/24"
    gw     = "192.168.9.2"
  }
}

variable "lxc_password" {
  description = "Password for lxc"
  type        = string
  sensitive   = true
}


