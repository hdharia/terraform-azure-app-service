# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.environment}"
  version = "1.1.2"
}

resource "azurerm_resource_group" "asp-tech-summit"
{
  name = "asp-tech-summit-hd"
  location = "usgovvirginia"
}

resource "azurerm_app_service_plan" "asp-tech-summit"
{
  name = "asp-tech-summit-plan"
  resource_group_name = "${azurerm_resource_group.asp-tech-summit.name}"
  location = "${azurerm_resource_group.asp-tech-summit.location}"

  sku
  {
    tier = "Standard"
    size = "S3"
  }
}

resource "azurerm_app_service" "asp-tech-summit" {
  name                = "asp-tech-summit-webapp"
  location            = "${azurerm_resource_group.asp-tech-summit.location}"
  resource_group_name = "${azurerm_resource_group.asp-tech-summit.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp-tech-summit.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    php_version = "7.1"
    default_documents = ["hostingstart.html"]
  }

  app_settings {
    "HOST" = "${var.HOST}"
    "AUTH_KEY" = "${var.AUTH_KEY}"
    "CONTAINER_ID" = "ToDoList_Prod"
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
  }
}

resource "azurerm_app_service_slot" "asp-tech-summit" {

  name                = "dev"
  app_service_name    = "${azurerm_app_service.asp-tech-summit.name}"
  location            = "${azurerm_resource_group.asp-tech-summit.location}"
  resource_group_name = "${azurerm_resource_group.asp-tech-summit.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp-tech-summit.id}"

  site_config {
    dotnet_framework_version = "v4.0"
    php_version = "7.1"
    default_documents = ["hostingstart.html"]
  }

  app_settings {
    "HOST" = "${var.HOST}"
    "AUTH_KEY" = "${var.AUTH_KEY}"
    "CONTAINER_ID" = "ToDoList_Dev"
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
  }
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.asp-tech-summit.default_site_hostname}"
}

output "app_service_dev_default_hostname" {
  value = "https://${azurerm_app_service_slot.asp-tech-summit.default_site_hostname}"
}


