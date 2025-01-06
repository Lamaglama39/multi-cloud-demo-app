data "aws_ami" "amazonlinux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"

    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

data "http" "ipv4_icanhazip" {
  url = "http://ipv4.icanhazip.com/"
}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

data "template_file" "azure_cloud_init" {
  template = file("${path.root}/conf/avm_cloud_init.yaml")
}
