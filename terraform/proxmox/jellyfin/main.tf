resource "proxmox_lxc" "Media-Server" {
  target_node  = "proxmox"
  hostname     = "Media-Server2"
  ostemplate   = "zfs-data_mp:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password     = var.lxc_password
  unprivileged = true
  cores        = 6
  memory       = 16384
  vmid         = 110
  start        = true
  ssh_public_keys = <<-EOT
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsYRkCx0uNh2qxXw5MX0xHTk25puTJgbORwnz/xtqpw mba-m1@MBA-M1s-MacBook-Air.local
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKt+18o7jPac6M5BESRXx2B1pDZ3YlqxeWWrojCvi0Ky root@Ansible
  EOT
  // Terraform will crash without rootfs defined
  rootfs {
    storage = "zfs-data_mp"
    size    = "10G"
  }
  mountpoint {
    key     = "1"
    slot    = 1
    storage = "/mnt/storage/media"
    volume  = "/mnt/storage/media"
    mp      = "/media"
    size    = "0G"
  }
  mountpoint {
    key     = "2"
    slot    = 2
    storage = "/mnt/cache/"
    volume  = "/mnt/cache/"
    mp      = "/raid0"
    size    = "0G"
  }

  features {
    nesting = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.9.154/24"
    gw     = "192.168.9.2"
  }
}

variable "lxc_password" {
  description = "Password for lxc"
  type        = string
  sensitive   = true
}

