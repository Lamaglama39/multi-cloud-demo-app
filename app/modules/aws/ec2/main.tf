module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7.1"

  for_each = var.server_instances_map

  name          = "${var.app_name}-${var.subnet_id}-ec2"
  instance_type = each.value.instance_type
  private_ip    = each.value.private_ip

  iam_instance_profile   = var.iam_role
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  key_name               = var.key_name

  ami                         = each.value.ami
  associate_public_ip_address = each.value.associate_public_ip_address
  user_data                   = each.value.user_data
}
