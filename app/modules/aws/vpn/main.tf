resource "aws_customer_gateway" "main" {
  bgp_asn    = var.bgp_asn
  ip_address = var.ip_address
  type       = var.type

  tags = {
    Name = "${var.app_name}-cgw"
  }
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = var.vpn_gateway_id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = var.type
  static_routes_only  = var.static_routes_only

  tags = {
    Name = "${var.app_name}-vpn-connection"
  }
}

resource "aws_vpn_connection_route" "main" {
  for_each = toset(var.address_space)

  vpn_connection_id      = aws_vpn_connection.main.id
  destination_cidr_block = each.key
}
