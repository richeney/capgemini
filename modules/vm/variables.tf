variable "name" {
    default     = "capgemini-test"
    description = "Virtual machine name"
}

variable "resource_group" {
    default     = "capgemini-test"
    description = "Name of the existing resource group for the virtual machine"
}

variable "subnet_id" {
  description   = "The subnet id of the virtual network where the virtual machines will reside."
  type          = "string"
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed"
  default     = "overlord"
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM."
  default     = "~/.ssh/id_rsa.pub"
}

variable "custom_data" {
  description = "The custom data to supply to the machine. This can be used as a cloud-init for Linux systems."
  default     = ""
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  // default     = "Standard_DS1_V2"
  default     = "Standard_B1s"
}

variable "image_id" {
  description = "Custom image ID. Overrides the publisher / offer / sku / version."
  default     = ""
}

variable "vm_os_publisher" {
  description = "Platform image OS publisher. Defaults to Canonical."
  default     = ""
}

variable "vm_os_offer" {
  description = "Platform image OS offer. Defaults to UbuntuServer"
  default     = ""
}

variable "vm_os_sku" {
  description = "Platform image OS sku. Defaults to 16.04-LTS"
  default     = ""
}

variable "vm_os_version" {
  description = "Platform image OS version. Defaults to latest."
  default     = ""
}

variable "os_managed_disk_id" {
    description = "Specify managed disk ID for OS disk attachment. Default is empty, i.e. create from image."
    default     = ""
}

variable "tags" {
  type        = "map"
  description = "A map of the tags to use on the resources that are deployed with this module."
  default = {}
}

variable "pip" {
  description = "Boolean to create public IP or not. Needs to be true if setting pip_dns."
  default     = false
}

variable "storage_account_type" {
  description = "Storage Account type"
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  default     = 50
}

variable "data_disk" {
  description = "Set to true to add a datadisk."
  default     = false
}

variable "accelerated" {
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = false
}