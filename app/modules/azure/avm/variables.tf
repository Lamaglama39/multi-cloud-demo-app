variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "network_security_group_id" {
  description = "The ID of the network security group"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
  
}

variable "delete_os_disk_on_termination" {
  description = "Whether to delete the OS disk when the virtual machine is deleted"
  type        = bool
  default = true
}

variable "storage_image_reference" {
  type = map(string)
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "storage_os_disk" {
  type = map(string)
  default = {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

variable "os_profile" {
  type = map(string)
  default = {
    computer_name  = "myvm"
    admin_username = "azureuser"
    custom_data    = ""
  }
}

variable "public_ip_id" {
  description = "The ID of the public IP address"
  type        = string
}

variable "private_ip_address" {
  description = "The private IP address of the network interface"
  type        = string
}

variable "public_key" {
  description = "The public key used for SSH access"
  type        = string
}
