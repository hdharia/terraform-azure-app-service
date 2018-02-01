# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.environment}"
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
    default_documents = ["hostingstart.html"]
  }



}