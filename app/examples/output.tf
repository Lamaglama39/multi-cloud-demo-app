# ##################################################
# # vm connection
# ##################################################

output "ec2_ssh" {
  value = "ssh -i ${path.root}/.key_pair/demo-multi-cloud-app ec2-user@${module.aws_ec2.ec2.ec2.public_ip}"
}

output "avm_ssh" {
  value = "ssh -i ${path.root}/.key_pair/demo-multi-cloud-app azureuser@${module.azure_public_ip_avm.azurerm_public_ip.ip_address}"
}

output "gce_ssh" {
  value = "gcloud compute ssh ${local.app_name}-gce --tunnel-through-iap"
}

# ##################################################
# # web site connection
# ##################################################

output "cloudfront_domain" {
  value = "curl https://${module.aws_cdn.cdn.cloudfront_distribution_domain_name}"
}

output "alb_domain" {
  value = "curl http://${module.aws_alb.alb.dns_name}"
}
