provider "azurerm" {
  features {}
}

resource "azurerm_role_definition" "role_definition_${random_integer}" {
  name = "role-definition-${random_integer}"
  scope = "/"
  permissions {
    actions = [
      "*"
    ]
    data_actions = [
      "*"
    ]
    not_data_actions = []
  }
}

resource "azurerm_role_assignment" "role_assignment_${random_integer}" {
  name                = "role-assignment-${random_integer}"
  scope               = "/"
  role_definition_id  = azurerm_role_definition.example_role_definition_${random_integer}.id
  principal_id        = "principal_id_here"  # Replace with the principal ID
}

resource "azurerm_virtual_machine" "virtual_machine_${random_integer}" {
  count                 = 2
  name                  = vm-${random_integer}-${count.index}"
  location              = "East US"
  resource_group_name   = "resource-group-${random_integer}"
  vm_size               = "Standard_DS1_v2"

  os_profile {
    computer_name  = "vm-${random_integer}-${count.index}"
    admin_username = "adminuser"
    admin_password = "Password1234!"  
  }

  tags = {
    environment = "production"
  }
}
