terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.1.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.14.0"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key     = var.vultr_api_key
  rate_limit  = 700
  retry_limit = 3
}

# Configure Cloudflare
provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

resource "cloudflare_record" "strapi_api_a" {
  count   = var.cloudflare_enabled ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.strapi_srv_domain
  value   = vultr_instance.strapi_server.main_ip
  type    = "A"
  ttl     = "1"
  proxied = false
}

resource "vultr_ssh_key" "strapi_ssh_key" {
  name    = "strapi-ssh-key"
  ssh_key = var.ssh_key
}

resource "vultr_firewall_group" "strapi_app" {
  description = "Strapi Application firewall rules"
}

resource "vultr_firewall_group" "strapi_db" {
  description = "Strapi Database firewall rules"
}

resource "vultr_firewall_rule" "app_tcp_debug_1337" {
  firewall_group_id = vultr_firewall_group.strapi_app.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "1337"
  notes             = "app debug strapi"
}

resource "vultr_firewall_rule" "app_tcp_80" {
  firewall_group_id = vultr_firewall_group.strapi_app.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "app http"
}

resource "vultr_firewall_rule" "app_tcp_443" {
  firewall_group_id = vultr_firewall_group.strapi_app.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "app https"
}

resource "vultr_firewall_rule" "app_tcp_22" {
  firewall_group_id = vultr_firewall_group.strapi_app.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "app ssh"
}

resource "vultr_firewall_rule" "db_tcp_22" {
  firewall_group_id = vultr_firewall_group.strapi_db.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "db ssh"
}

resource "vultr_firewall_rule" "db_tcp_3306" {
  firewall_group_id = vultr_firewall_group.strapi_db.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = vultr_instance.strapi_server.main_ip
  subnet_size       = 32
  port              = "3306"
  notes             = "db mysql"
}

resource "vultr_instance" "strapi_server" {
  plan                   = var.strapi_plan
  region                 = var.region
  os_id                  = var.instance_os
  label                  = var.strapi_label
  tag                    = var.instance_tag
  hostname               = var.strapi_hostname
  enable_ipv6            = var.strapi_ipv6
  backups                = var.strapi_server_backups
  ddos_protection        = true
  activation_email       = false
  enable_private_network = false
  ssh_key_ids            = [vultr_ssh_key.strapi_ssh_key.id]
  firewall_group_id      = vultr_firewall_group.strapi_app.id
}

resource "vultr_instance" "strapi_database" {
  plan                   = var.database_plan
  region                 = var.region
  os_id                  = var.instance_os
  label                  = var.database_label
  tag                    = var.instance_tag
  hostname               = var.database_hostname
  enable_ipv6            = false
  backups                = var.strapi_database_backups
  ddos_protection        = false
  activation_email       = false
  enable_private_network = false
  ssh_key_ids            = [vultr_ssh_key.strapi_ssh_key.id]
  firewall_group_id      = vultr_firewall_group.strapi_db.id
}