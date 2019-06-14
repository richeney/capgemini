provider "azurerm" {
  version = ">= 1.30.1"
}

data "azurerm_resource_group" "rg" {
    name    = "${var.resource_group}"
}

locals {
    vmname      = "capgemini"
    tags        = "${merge(data.azurerm_resource_group.rg.tags, var.tags)}"
}



resource "azurerm_public_ip" "vm" {
  count                        = var.pip ? 1 : 0
  name                         = "${local.vmname}-pip"
  location                     = "${data.azurerm_resource_group.rg.location}"
  resource_group_name          = "${data.azurerm_resource_group.rg.name}"
  tags                         = "${local.tags}"

  allocation_method            = "Dynamic"
  domain_name_label            = "${local.vmname}"
}

resource "azurerm_network_security_group" "vm" {
  name                = "${local.vmname}-nsg"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  tags                = "${local.tags}"

  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH in from all locations"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "vm" {
  name                          = "${local.vmname}-nic"
  location                      = "${data.azurerm_resource_group.rg.location}"
  resource_group_name           = "${data.azurerm_resource_group.rg.name}"
  tags                          = "${local.tags}"

  network_security_group_id     = "${azurerm_network_security_group.vm.id}"
  enable_accelerated_networking = "${var.accelerated}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    // public_ip_address_id          = "${var.pip ? element(concat(azurerm_public_ip.vm.*.id, list("")), 0) : ""}"
    public_ip_address_id          = var.pip ? element(concat(azurerm_public_ip.vm.*.id, list("")), 0) : ""
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                          = "${local.vmname}"
  location                      = "${data.azurerm_resource_group.rg.location}"
  resource_group_name           = "${data.azurerm_resource_group.rg.name}"
  tags                          = "${local.tags}"
  vm_size                       = "${var.vm_size}"
  network_interface_ids         = [ "${azurerm_network_interface.vm.id}" ]
  delete_os_disk_on_termination = false

  storage_image_reference {
    id        = "${var.image_id}"
    publisher = "${var.image_id != "" ? "" : coalesce(var.vm_os_publisher, "Canonical")}"
    offer     = "${var.image_id != "" ? "" : coalesce(var.vm_os_offer, "UbuntuServer")}"
    sku       = "${var.image_id != "" ? "" : coalesce(var.vm_os_sku, "16.04-LTS")}"
    version   = "${var.image_id != "" ? "" : coalesce(var.vm_os_version, "latest")}"
  }

  storage_os_disk {
    name              = "${local.vmname}-os"
    create_option     = length(var.os_managed_disk_id) > 0 ? "Attach" : "FromImage"
    caching           = "ReadWrite"
    os_type           = "Linux"
    managed_disk_id   = length(var.os_managed_disk_id) > 0 ? var.os_managed_disk_id : null
    managed_disk_type = "${var.storage_account_type}"
  }

  storage_data_disk {
    name              = "${local.vmname}-data"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "${var.data_disk_size_gb}"
    managed_disk_type = "${var.storage_account_type}"
  }

  os_profile {
    computer_name  = "${local.vmname}"
    admin_username = "${var.admin_username}"
    // admin_password = "${var.admin_password}"
    custom_data    = "${var.custom_data}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file("${var.ssh_key}")}"
    }
  }
}
