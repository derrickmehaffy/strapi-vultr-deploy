###################
# Global Settings #
###################
# Vultr API Key
# vultr_api_key = "your-vultr-api-key"

# If you already have an SSH key on Vultr
# you can use the same public key and it will not be duplicated
# ssh_key = "ssh-rsa your-ssh-key you@your-host"

# WIP don't use yet
#ssh_key_id = ""

# See the following API for Regions: https://api.vultr.com/v2/regions
region = "sea" # Seattle, WA  USA

#######################
# Cloudflare Settings #
#######################
# Cloudflare is disabled by default
# DO NOT DISABLE, no cloudflare support is WIP
cloudflare_enabled = true
# cloudflare_email   = "test@test.com"
# cloudflare_api_key = "abc123"
# cloudflare_zone_id = "abc123"
# strapi_srv_domain  = "api-test"

####################
# Network Settings #
####################

# Vultr Private network currently is not working via their API
#network_desc        = "Strapi Private Network"
#network_subnet      = "10.0.0.1"
#network_subnet_size = "24"

#####################
# Instance Settings #
#####################

# See the following API for OS IDs: https://api.vultr.com/v2/os
instance_os  = "387" # Ubuntu 20.04 LTS
instance_tag = "strapi"

##############################
# Strapi App Server Settings #
##############################

# See the following API for Plans: https://api.vultr.com/v2/plans
strapi_plan           = "vc2-1c-2gb" # Cost ~10$/month
strapi_label          = "my-strapi-srv"
strapi_hostname       = "my-strapi-srv"
strapi_ipv6           = false
strapi_server_backups = false

###################################
# Strapi Database Server Settings #
###################################

# See the following API for Plans: https://api.vultr.com/v2/plans
database_plan           = "vc2-2c-4gb" # Cost ~20$/month
database_label          = "my-strapi-db"
database_hostname       = "my-strapi-db"
strapi_database_backups = false
