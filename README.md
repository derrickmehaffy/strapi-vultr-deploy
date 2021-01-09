# Strapi Vultr Deployment with Terraform & Ansible

**WORK IN PROGRESS**

## Foreword

Please keep in mind, while I do work for Strapi, all the work of this repo is of a personal nature. This repo is not maintained by Strapi (the company) and there is no guarantee, express or implied that it will be actively maintained. I am producing this project in my free time and will update it when I can.

Issues opened asking for updates or general spam will be closed and ignored. That being said, I openly welcome you to report any issues you find and I'll address them when I can. Naturally I am certainly no Terraform or Ansible pro and I welcome any outside contribution to help out.

## About

This deploy template uses Terraform to configure and deploy two Vultr instances, one for a MariaDB database and one for a Strapi application. It will automatically add an SSH key and create a few service users as well as register the new Strapi instance in Cloudflare. It will also register an SSL Certificate with Let's Encrypt for the subdomain and setup Nginx to reverse proxy Strapi.

## Overall Requirements

Below are some of the global requirements when using this deployment automation

- You are using Vultr for your infrastructure
- You already own a domain
- You are using Cloudflare to manage your DNS and have your domain already configured
- You don't mind running two Vultr Instances, one for each application (DB and Strapi)
- You want to run Strapi on a subdomain (Sub-folder is not supported)
- You understand both Terraform and Ansible and are willing to make modifications to suite your needs
- You already have a Strapi application located in a Git Repo

You can find a sample application [located here](https://github.com/derrickmehaffy/strapi-deploy-example), with some configurations applied to work with this template. Please note, it's quite likely I will not keep this project up to date with the latest Strapi version. Use it at your own risk, and always make sure to check the [Strapi Documentation](https://strapi.io/documentation) for the latest configuration settings.

## Terraform

Terraform within this template does the following:

1. Uses the `vultr/vultr` and `cloudflare/cloudflare` providers
2. Creates a DB Instance (Default type is `vc2-2c-4gb`) ~20$/month
3. Creates a Strapi Instance (Default type is `vc2-1c-2gb`) ~10$/month
4. Deploys a user provided SSH key to both instances
5. Registers an A record for the Strapi instance on a subdomain in Cloudflare
6. Automatically outputs an Ansible inventory file to the proper directory
7. Automatically outputs an Ansible vars file to the proper directory

### T-Requirements

- Vultr API Key
- Cloudflare email
- Cloudflare API Key
- Cloudflare Zone ID for Domain
- Have a subdomain in mind (example: `api-test`)
- Have an SSH public key (Doesn't currently support existing keys, yet)
- Terraform already installed

### Variables

Variables are set in the `./terraform/terraform.tfvars`, there is an [example file](./terraform/example.tfvars) that you can copy and modify.

```bash
cp terraform/examples.tfvars terraform/terraform.tfvars
```

| Var Name              | Type    | Default       | Required |
| --------------------- | ------- | ------------- | -------- |
| vultr_api_key         | string  | null          | Y        |
| ssh_key               | string  | null          | Y        |
| region                | string  | sea           | Y        |
| cloudflare_enabled    | boolean | true          | Y        |
| cloudflare_email      | string  | null          | Y        |
| cloudflare_api_key    | string  | null          | Y        |
| cloudflare_zone_id    | string  | null          | Y        |
| strapi_srv_domain     | string  | null          | Y        |
| instance_os           | string  | 387           | Y        |
| instance_tag          | string  | strapi        | N        |
| strapi_plan           | string  | vc2-1c-2gb    | Y        |
| strapi_label          | string  | my-strapi-srv | Y        |
| strapi_hostname       | string  | my-strapi-srv | Y        |
| strapi_ipv6           | boolean | false         | N        |
| strapi_server_backups | boolean | false         | N        |
| database_plan         | string  | vc2-2c-4gb    | Y        |

There are certain variables that are pulled from Vultr Public APIs:

- `region` => https://api.vultr.com/v2/regions
- `instance_os` => https://api.vultr.com/v2/os
- `strapi_plan` / `database_plan` => https://api.vultr.com/v2/plans

**Do not go below `vc2-1c-2gb` for the Strapi instance or the Admin panel will not build!**

The Database instance can be dropped to `vc2-1c-2gb` to decrease cost, but it's not recommended.

### Terraform Instructions

1. Use the above command to copy the example vars file
2. Configure your variables
3. Navigate to the terraform directory and run `terraform init` (This will install the required providers for Vultr and Cloudflare)
4. Run `terraform plan --out plan.txt` to get a summery of what terraform will do
5. If the plan looks good run `terraform apply plan.txt` and it will ask you to confirm, type `yes`
6. Let Terraform do it's thing, this might take a few minutes
7. Validate that Terraform created the `./ansible/inventory` file
8. Validate that Terraform created the `./ansible/tf_vars/tf_vars.yml` file

Congrats, you just spun up the infrastructure, move on to Ansible to install the services and deploy your application.

## Ansible

### A-Requirements

## Other deploy scripts I have created or plan to

- strapi-aws-deploy (Coming soon)
- strapi-digitalocean-deploy (Coming soon)
- strapi-googlecloud-deploy (Coming soon)
- strapi-linode-deploy (Coming soon)
- strapi-vultr-deploy (You are here?)

## License

This entire repo is licensed under [MIT](./LICENSE) and you are free to use it as you please. Do keep in mind that this license does not cover any of the Ansible roles/collections specified in the [requirements](./ansible/requirements.yml) file nor any of the Terraform providers.
