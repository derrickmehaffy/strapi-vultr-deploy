output "strapi_server_public_ip" {
  value = vultr_instance.strapi_server.main_ip
}

output "strapi_server_label" {
  value = vultr_instance.strapi_server.label
}

output "strapi_server_id" {
  value = vultr_instance.strapi_server.id
}

output "strapi_database_public_ip" {
  value = vultr_instance.strapi_database.main_ip
}

output "strapi_database_label" {
  value = vultr_instance.strapi_database.label
}

output "strapi_database_id" {
  value = vultr_instance.strapi_database.id
}

# output "strapi_fqdn" {
#   value = cloudflare_record.strapi_api_a.hostname
# }

# output "strapi_server_private_ip" {
#   value = vultr_instance.strapi_server.internal_ip
# }

# output "strapi_database_private_ip" {
#   value = vultr_instance.strapi_database.internal_ip
# }

### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tmpl",
    {
      strapi-label = vultr_instance.strapi_server.label,
      strapi-id    = vultr_instance.strapi_server.id,
      strapi-ip    = vultr_instance.strapi_server.main_ip,
      # strapi-pip = vultr_instance.strapi_server.internal_ip,
      database-label = vultr_instance.strapi_database.label,
      database-id    = vultr_instance.strapi_database.id,
      database-ip    = vultr_instance.strapi_database.main_ip,
      # database-pip = vultr_instance.strapi_database.internal_ip
    }
  )
  filename = "../ansible/inventory"
}
