resource "azurerm_network_security_group" "nsg" {
    resource_group_name = "${var.resource_group_name}"  
    location            = "${var.location}"
    name                = "${var.security_group_name}"
    tags                = "${var.tags}"
}

resource "azurerm_network_security_rule" "custom_rules" {
    count                       = "${length(var.custom_rules)}"
    resource_group_name         = "${var.resource_group_name}"
    name                        = "${lookup(var.custom_rules[count.index], "name", "default_rule_name")}"
    priority                    = "${lookup(var.custom_rules[count.index], "priority")}"
    direction                   = "${lookup(var.custom_rules[count.index], "direction", "Any")}"
    access                      = "${lookup(var.custom_rules[count.index], "access", "Allow")}"
    protocol                    = "${lookup(var.custom_rules[count.index], "protocol", "*")}"
    source_port_range           = "${lookup(var.custom_rules[count.index], "source_port_range", "*" )}"
    destination_port_range      = "${lookup(var.custom_rules[count.index], "destination_port_range", "*" )}"
    source_address_prefix       = "${lookup(var.custom_rules[count.index], "source_address_prefix", "*")}"
    destination_address_prefix  = "${lookup(var.custom_rules[count.index], "destination_address_prefix", "*")}"
    description                 = "${lookup(var.custom_rules[count.index], "description", "Security rule for ${lookup(var.custom_rules[count.index], "name", "default_rule_name")}")}"
    network_security_group_name = "${var.security_group_name}"

    depends_on                  = ["azurerm_network_security_group.nsg"]
}
