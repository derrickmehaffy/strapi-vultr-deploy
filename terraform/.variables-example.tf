###################
# Global Settings #
###################

# If you already have an SSH key on Vultr
# you can use the same desc and public key and it will not be duplicated

variable "ssh_key" {
  type        = string
  description = "The new Strapi SSH key you generated with ssh-keygen."
  default     = "ssh-rsa yourKey yourUser@yourHost"
}

# See the following API for Regions: https://api.vultr.com/v2/regions

variable "region" {
  type        = string
  description = "The physical location of the resources"
  default     = "sea"
}

####################
# Network Settings #
####################

# Vultr Private network currently is not working via their API

# variable "network_desc" {
#   type        = string
#   description = "The private network name used to link Strapi resources"
#   default     = "strapi private network"
# }

# variable "network_subnet" {
#   type        = string
#   description = "The private subnet"
#   default     = "10.0.0.0"
# }

# variable "network_subnet_size" {
#   type        = string
#   description = "The private subnet size"
#   default     = "24"
# }

#####################
# Instance Settings #
#####################

# See the following API for OS IDs: https://api.vultr.com/v2/os

variable "instance_os" {
  type        = string
  description = "The Operating system installed on the servers"
  default     = "387"
}

variable "instance_tag" {
  type        = string
  description = "Tag assigned to the instances"
  default     = "strapi"
}

##############################
# Strapi App Server Settings #
##############################

# See the following API for Plans: https://api.vultr.com/v2/plans

variable "strapi_plan" {
  type        = string
  description = "The size of the Vultr strapi instance"
  default     = "vc2-1c-2gb"
}

variable "strapi_label" {
  type        = string
  description = "The label assigned to the strapi instance"
  default     = "my-strapi-srv"
}

variable "strapi_hostname" {
  type        = string
  description = "The hostname of the strapi instance"
  default     = "my-strapi-srv"
}

variable "strapi_ipv6" {
  type        = bool
  description = "Enable IPv6 on the strapi instance"
  default     = false
}

variable "strapi_server_backups" {
  type        = bool
  description = "Enable auto backup on the database instance, warning this cost 2$ per month"
  default     = false
}

###################################
# Strapi Database Server Settings #
###################################

# See the following API for Plans: https://api.vultr.com/v2/plans

variable "database_plan" {
  type        = string
  description = "The size of the Vultr database instance"
  default     = "vc2-1c-2gb"
}

variable "database_label" {
  type        = string
  description = "The label assigned to the database instance"
  default     = "my-strapi-db"
}

variable "database_hostname" {
  type        = string
  description = "The hostname of the database instance"
  default     = "my-strapi-srv"
}

variable "strapi_database_backups" {
  type        = bool
  description = "Enable auto backup on the database instance, warning this cost 2$ per month"
  default     = false
}