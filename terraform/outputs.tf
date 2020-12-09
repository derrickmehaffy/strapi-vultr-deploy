output "strapi_server_public_ip" {
  value = vultr_instance.strapi_server.main_ip
}

# output "strapi_server_private_ip" {
#   value = vultr_instance.strapi_server.internal_ip
# }

output "strapi_database_public_ip" {
  value = vultr_instance.strapi_database.main_ip
}

# output "strapi_database_private_ip" {
#   value = vultr_instance.strapi_database.internal_ip
# }