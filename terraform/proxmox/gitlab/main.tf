resource "proxmox_lxc" "Gitlab" {
  target_node  = "proxmox"
  hostname     = "Gitlab"
  ostemplate   = "zfs-data_mp:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password     = var.lxc_password
  unprivileged = true
  cores        = 2
  memory       = 4096
  vmid         = 116
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

