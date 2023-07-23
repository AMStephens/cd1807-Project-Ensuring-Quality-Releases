resource "azurerm_service_plan" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  os_type = "Windows"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "test" {
  name                = "WebAppAlice12345"
  #name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  service_plan_id     = azurerm_service_plan.test.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 0
  }
  site_config {
    always_on = false
  }
}

data "azurerm_monitor_action_group" "existing" {
  name                = "Alices_Alerts"
  resource_group_name = "alices_resource_group"
}

resource "azurerm_monitor_metric_alert" "main" {
  name                = "alices-metric-alert"
  resource_group_name = "alices_resource_group"
  scopes              = [azurerm_linux_web_app.test.id]
  target_resource_type = "Microsoft.Web/sites"
  description         = "Metric alert"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "FailedRequests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.existing.id
  }
}
