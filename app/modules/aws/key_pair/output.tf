output "key_pair" {
  value = module.key_pair
}

output "public_key" {
  value = tls_private_key.this.public_key_openssh
}
