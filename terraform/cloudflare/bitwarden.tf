resource "null_resource" "install_bw_cli" {
  provisioner "local-exec" {
    command = <<EOL
      curl -s -L "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o bw-linux-amd64
      chmod +x bw-linux-amd64
      sudo mv bw-linux-amd64 /usr/local/bin/bw
    EOL
  }
  
  triggers = {
    always_run = "${timestamp()}"
  }
}


data "bitwarden_item_login" "secret" {
    id = "c90a764c-a2a1-4705-bce8-b078009b7e2b"
}

output bitwarden {
    value = data.bitwarden_item_login.secret.*
}