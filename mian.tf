provider "azurerm" {
  features {}
}

# Step 1: Create an IAM role (Azure role)
resource "azurerm_role_definition" "example_role_definition" {
  name        = "example-role-definition"
  scope       = "/subscriptions/d6b3f6a1-217b-4a82-b3c5-4b88c7455ebf"  # Subscription ID
  permissions {
    actions = [
      "Microsoft.Storage/*/read",
      "Microsoft.Network/*/read",
      "Microsoft.Compute/*/read"
    ]
  }
}

# Step 2: Create an appropriate policy
data "azurerm_policy_definition" "example_policy_definition" {
  name = "example-policy-definition"
}

# Step 3: Associate the policy with the created role
resource "azurerm_role_assignment" "example_role_assignment" {
  name                = "example-role-assignment"
  scope               = "/subscriptions/d6b3f6a1-217b-4a82-b3c5-4b88c7455ebf"  # Subscription ID
  role_definition_name = azurerm_role_definition.example_role_definition.name
  principal_id        = "poojanChef@outlook.com"  # User Principal Name (UPN)
  policy_definition_id = data.azurerm_policy_definition.example_policy_definition.id
}

# Step 4: Use the role to create Azure resources
resource "azurerm_virtual_machine" "example_virtual_machine" {
  name                  = "example-vm"
  location              = "East US"
  resource_group_name   = "example-resource-group"
  vm_size               = "Standard_DS1_v2"

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
    admin_password = "Password1234!"  # Replace with your password
  }

  tags = {
    environment = "production"
  }
}

# Step 5: Disassociate the policy from the role
resource "azurerm_role_assignment" "example_role_assignment_removal" {
  name                = "example-role-assignment-removal"
  scope               = "/subscriptions/d6b3f6a1-217b-4a82-b3c5-4b88c7455ebf"  # Subscription ID
  role_definition_name = azurerm_role_definition.example_role_definition.name
  principal_id        = "poojanChef@outlook.com"  # User Principal Name (UPN)
  policy_definition_id = data.azurerm_policy_definition.example_policy_definition.id
  depends_on          = [azurerm_virtual_machine.example_virtual_machine]
}

# Step 6: Remove the role
resource "azurerm_role_assignment" "example_role_removal" {
  name                = "example-role-removal"
  scope               = "/subscriptions/d6b3f6a1-217b-4a82-b3c5-4b88c7455ebf"  # Subscription ID
  role_definition_name = azurerm_role_definition.example_role_definition.name
  principal_id        = "poojanChef@outlook.com"  # User Principal Name (UPN)
  depends_on          = [azurerm_role_assignment.example_role_assignment_removal]
}
