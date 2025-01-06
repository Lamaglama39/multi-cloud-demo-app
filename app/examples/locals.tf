locals {
  app_name     = "demo-multi-cloud-app"
  current-ip   = chomp(data.http.ipv4_icanhazip.body)
  allowed-cidr = "${local.current-ip}/32"

  ##################################################
  # aws
  ##################################################
  aws_region = "ap-northeast-1"

  aws_cidr           = "192.168.10.0/24"
  aws_azs            = ["ap-northeast-1a", "ap-northeast-1c"]
  aws_public_subnets = ["192.168.10.0/26", "192.168.10.64/26"]

  ## security group
  security_groups = {
    alb = {
      name        = "alb"
      description = "alb"
    },
    ec2 = {
      name        = "ec2"
      description = "ec2"
    },
  }

  ## security group rules
  sg_rules = {
    alb = {
      security_group_id = module.aws_sg.alb.sg.id
      rule = [
        {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = [local.allowed-cidr]
        },
        {
          type            = "ingress"
          from_port       = 80
          to_port         = 80
          protocol        = "tcp"
          prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
        },
        {
          type                     = "egress"
          from_port                = 80
          to_port                  = 80
          protocol                 = "tcp"
          source_security_group_id = module.aws_sg.ec2.sg.id
        },
        {
          type        = "egress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["192.168.20.0/24"]
        },
        {
          type        = "egress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["192.168.30.0/26"]
        },
      ]
    },
    ec2 = {
      security_group_id = module.aws_sg.ec2.sg.id
      rule = [
        {
          type        = "ingress"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [local.allowed-cidr]
        },
        {
          type                     = "ingress"
          from_port                = 80
          to_port                  = 80
          protocol                 = "tcp"
          source_security_group_id = module.aws_sg.alb.sg.id
        },
        {
          type        = "egress"
          from_port   = 0
          to_port     = 65535
          protocol    = -1
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
    },
  }

  ## ec2
  key_algorithm    = "ED25519"
  private_key_file = "${path.root}/.key_pair/${local.app_name}"

  trusted_role_services    = ["ec2.amazonaws.com"]
  instance_iam_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess", ]

  instances = {
    ec2 = {
      name                        = "ec2"
      instance_type               = "t2.micro"
      private_ip                  = "192.168.10.10"
      ami                         = data.aws_ami.amazonlinux_2023.id
      associate_public_ip_address = true
      user_data                   = file("${path.root}/conf/aws_userdata.sh")
    }
  }

  ## ALB target group
  path_config = {
    ec2 = {
      ip                = "192.168.10.10"
      availability_zone = null
      priority          = 10
    }
    avm = {
      ip                = "192.168.20.10"
      availability_zone = "all"
      priority          = 20
    }
    gce = {
      ip                = "192.168.30.10"
      availability_zone = "all"
      priority          = 30
    }
  }

  ##################################################
  # azure
  ##################################################
  azure_cidr   = ["192.168.20.0/24"]
  azure_region = "Japan East"

  ## azure vnet
  azure_subnets = {
    "subnet1" = {
      name             = "${local.app_name}-subnet"
      address_prefixes = ["192.168.20.0/26"]
    }
    "subnet2" = {
      name             = "GatewaySubnet"
      address_prefixes = ["192.168.20.64/26"]
    }
  }

  ## azure vpn
  azure_vpn_tunnels = {
    "1" = {
      gateway_name    = "aws-gateway-1"
      connection_name = "aws-connection-1"
      gateway_address = module.aws_azure_vpn.aws_vpn_connection.tunnel1_address
      pre_shared_key  = module.aws_azure_vpn.aws_vpn_connection.tunnel1_preshared_key
      address_space   = [local.aws_cidr]
    },
    "2" = {
      gateway_name    = "aws-gateway-2"
      connection_name = "aws-connection-2"
      gateway_address = module.aws_azure_vpn.aws_vpn_connection.tunnel2_address
      pre_shared_key  = module.aws_azure_vpn.aws_vpn_connection.tunnel2_preshared_key
      address_space   = [local.aws_cidr]
    }
  }

  ## azure avm
  azure_private_ip_address = "192.168.20.10"
  azure_vm_size            = "Standard_B1ls"
  azure_storage_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  azure_storage_os_disk = {
    name              = "azure-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  azure_os_profile = {
    computer_name  = "azure-avm"
    admin_username = "azureuser"
    custom_data    = data.template_file.azure_cloud_init.rendered
  }


  ##################################################
  # google cloud
  ##################################################
  google_project_id = var.project_id
  google_region     = "asia-northeast1"
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "networkmanagement.googleapis.com",
  ]

  ## gcp vpc
  routing_mode = "GLOBAL"
  gcp_subnets = [
    {
      subnet_name   = "${local.app_name}-google-cloud-subnet"
      subnet_ip     = "192.168.30.0/26"
      subnet_region = "asia-northeast1"
    }
  ]
  gcp_routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
  gcp_ingress_rules = [
    {
      name          = "ingress-rules"
      description   = "vpn traffic"
      source_ranges = ["192.168.10.0/24"]

      allow = [
        {
          protocol = "all"
        }
      ]
    }
  ]

  ## gcp vpn
  gcp_vpn_tunnels = {
    "aws-connection-1" = {
      shared_secret            = module.aws_gcp_vpn.aws_vpn_connection.tunnel1_preshared_key
      peer_ip                  = module.aws_gcp_vpn.aws_vpn_connection.tunnel1_address
      remote_traffic_selectors = [local.aws_cidr]
      local_traffic_selectors  = [local.gcp_subnets[0].subnet_ip]
    },
    "aws-connection-2" = {
      shared_secret            = module.aws_gcp_vpn.aws_vpn_connection.tunnel2_preshared_key
      peer_ip                  = module.aws_gcp_vpn.aws_vpn_connection.tunnel2_address
      remote_traffic_selectors = [local.aws_cidr]
      local_traffic_selectors  = [local.gcp_subnets[0].subnet_ip]
    }
  }

  gcp_vpn_routes = {
    "aws-connection-1" = {
      name       = "aws-connection-1"
      dest_range = local.aws_cidr
      priority   = 100
      vpn_tunnel = "aws-connection-1"
    },
    "aws-connection-2" = {
      name       = "aws-connection-2"
      dest_range = local.aws_cidr
      priority   = 200
      vpn_tunnel = "aws-connection-2"
    }
  }

  ## gcp vm
  gcp_firewall_rules = {
    "gce" = {
      source_ranges = [local.allowed-cidr, "35.235.240.0/20"]
      allow = [
        { protocol = "tcp", ports = ["22", "80"] }
      ]
    }
  }

  gce_zone         = "asia-northeast1-a"
  gce_machine_type = "e2-micro"
  gce_boot_disk = {
    image = "debian-cloud/debian-12"
    size  = 10
    type  = "pd-standard"
  }

  gce_network_interface = {
    network            = module.gcp_vpc.vpc.network.network.name
    subnetwork         = module.gcp_vpc.vpc.subnets_self_links[0]
    nat_ip             = "192.168.30.10"
    enable_external_ip = true
  }

  gce_startup_script = file("${path.root}/conf/gcp_startup_script.sh")
}
