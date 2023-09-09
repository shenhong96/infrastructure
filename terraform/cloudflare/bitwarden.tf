resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo $PATH"
  }
}

# data "bitwarden_item_login" "secret" {
#     id = "c90a764c-a2a1-4705-bce8-b078009b7e2b"
# }

# output bitwarden {
#     value = data.bitwarden_item_login.secret.*
# }