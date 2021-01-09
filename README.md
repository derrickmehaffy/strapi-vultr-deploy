# Strapi Vultr Deployment with Terraform & Ansible

![strapi + ansible/terraform](./images/strapi+ansible_terraform.png)

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
- **You are not on Windows computer, sorry not sorry, use WSL**
- You are not trying to deploy on other operating systems besides Ubuntu LTS

You can find a sample application [located here](https://github.com/derrickmehaffy/strapi-deploy-example), with some configurations applied to work with this template. Please note, it's quite likely I will not keep this project up to date with the latest Strapi version. Use it at your own risk, and always make sure to check the [Strapi Documentation](https://strapi.io/documentation) for the latest configuration settings.

### To-do / Nice to have Features

- [ ] Support Deployment without Cloudflare / SSL / Domain
- [ ] Support existing Vultr SSH Key ID (WIP)
- [ ] Automatic testing of Deployed Strapi Application to ensure it's actually running, else rollback to previous version
- [ ] Support automatic database backup pre-deploy
- [ ] Support automatic database restore if new deploy fails and rollback is triggered
- [ ] Support for running SQL migration scripts to make Strapi version updates easier
- [ ] Clean up Ansible code to follow best-practices (I admit it's a bit messy)
- [ ] Support other Linux Distributions besides Ubuntu
- [ ] Support running Strapi in a Staging Environment (Optional 3rd instance)

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

### T-Variables

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

For modules used from Ansible-Galaxy / GitHub see the [requirements file](./ansible/requirements.yml).

Ansible within this template does the following:

### main.yml Playbook

1. Loads encrypted Variables from `crypt_vars/all.yml`
2. Loads tf_vars from Terraform via `tf_vars/tf_vars.yml`
3. Runs the Apt role to install a handful of required/useful packages
4. Sets up 3 users: root, devops, and deploy
5. Triggers the `strapi_database.yml` playbook

User definitions are as such (They all have no password set, aka disabled password):

- Root user => initial connection for main.yml, using defined SSH key in Terraform
- Devops user => "Admin" sudo user you should regularly use to connect or allow team members to connect to (adjust to fit your needs) and also used for the database/strapi server setup (stop using root people)
- Deploy user => Strapi's service user, what Strapi runs as (**Does not have sudo perms, this is intended!**)

Apt packages that are installed on both systems are:

- software-properties-common
- build-essential
- net-tools
- zip
- unzip

It will also automatically apply software updates using the `dist` upgrade and automatically remove packages that are no longer needed.

### playbooks/strapi_database.yml

1. Loads encrypted Variables from `crypt_vars/database.yml`
2. Loads tf_vars from Terraform via `tf_vars/tf_vars.yml`
3. Installs MariaDB v10.3
4. Creates a database for Strapi
5. Creates a user for Strapi
6. Sets user permissions on the database
7. Triggers the `strapi_server.yml` playbook

Database name and user are based on the labels you set for the Vultr instances in Terraform, thus the defaults are:

- DB Name: my-strapi-db
- DB User: my-strapi-admin

The password is stored in the `crypt_vars/database.yml` and this file should be encrypted (see instructions below on dealing with Ansible-Vault)

### playbooks/strapi_server.yml

1. Loads encrypted Variables from `crypt_vars/strapi.yml`
2. Loads encrypted Variables from `crypt_vars/database.yml`
3. Loads tf_vars from Terraform via `tf_vars/tf_vars.yml`
4. Installs Node via the version defined in `group_vars/strapi.yml` (default is v14)
5. Installs yarn
6. Installs the [Acme.sh client](https://github.com/acmesh-official/acme.sh) (way better than certbot)
7. Requests Let's Encrypt SSL Cert using Cloudflare DNS-01 Verification
8. Installs Nginx, configures upstream, deploys configs for HTTP => HTTPs
9. Creates the deploy directory and various child directories `/srv/deploy/*`
10. Installs [PM2](https://pm2.io/) globally
11. Sets up PM2 to be loaded on reboot and start previous services
12. Triggers the `strapi_dply.yml` playbook

### playbooks/strapi_dply.yml

First off don't ask why it's named this way, the Ansible linter I use throws errors if I use `deploy` and I'm lazy and don't feel like fixing it. `¯\_(ツ)_/¯`

1. Loads encrypted Variables from `crypt_vars/strapi.yml`
2. Loads encrypted Variables from `crypt_vars/database.yml`
3. Loads tf_vars from Terraform via `tf_vars/tf_vars.yml`
4. Uses the [ansistrano](https://github.com/ansistrano/deploy) deployment system to version deployments and make it easier to rollback if failures happen.
5. Pulls project from Git source
6. Pushes templated `.env` and `ecosystem.config.js` for Strapi and PM2
7. Installs node_modules (using yarn, fuck npm)
8. Builds the Strapi Admin **in production mode** (Stop deploying dev servers)
9. Starts/Reloads Strapi application

Eventually I want to add checking to ensure the Strapi project started correctly and do an automated DB backup. Should failures occur then it would run the rollback playbook and restore the DB from the backup.

### playbooks/strapi_rollback.yml

**This feature is not developed yet**

### A-Requirements

First off, if you are not familiar with Ansible-Vault what are you doing with your life? Go do some research. There is a default Ansible config that sets some sane defaults located [here](./ansible/ansible.cfg). I suggest you read through it to understand how it's setup.

This template uses various roles from Ansible-Galaxy and misc GitHub repos, I suggest you look at the requirements file and review their documentation if you plan to make changes. There is also a [script](./ansible/install_requirements.sh) to automatically install them.

Next you need to make a `vault_password` file at the ansible folder root to encrypt/decrypt the `crypt_vars/*` files. See the [example folder](./ansible/crypt_vars/example) and it's [README.md](./ansible/crypt_vars/example/README.md) for some templates and a sample encrypted file. There is a password generation script located [here](./ansible/scripts/gen_pwd.sh) for my fellow lazy folks. **Keep that password safe and handy, if you lose it, back to square one on configuring shit**

### A-Variables

Alright off to the variables, there is a lot so good luck :)
(You'll probably need to scroll the table, lots of info, sorry)

| Var Name                                       | Type    | Default                                                 | Required | File Path               | Automated |
| ---------------------------------------------- | ------- | ------------------------------------------------------- | -------- | ----------------------- | --------- |
| Various                                        | Various | Various                                                 | Various  | crypt_vars/all.yml      | N         |
| strapi_db_pass                                 | string  | null                                                    | Y        | crypt_vars/database.yml | N         |
| acme_sh_account_email                          | string  | null                                                    | Y        | crypt_vars/strapi.yml   | N         |
| acme_sh_default_dns_provider_api_keys.CF_KEY   | string  | null                                                    | Y        | crypt_vars/strapi.yml   | N         |
| acme_sh_default_dns_provider_api_keys.CF_Email | string  | null                                                    | Y        | crypt_vars/strapi.yml   | N         |
| apt_dependencies                               | array   | Various                                                 | Y        | group_vars/all.yml      | Y         |
| apt_upgrade                                    | string  | dist                                                    | Y        | group_vars/all.yml      | Y         |
| apt_autoremove                                 | boolean | yes                                                     | Y        | group_vars/all.yml      | Y         |
| mysql_packages                                 | array   | Various                                                 | Y        | group_vars/database.yml | Y         |
| mysql_bind_address                             | string  | 0.0.0.0                                                 | Y        | group_vars/database.yml | Y         |
| mysql_databases                                | object  | strapi_db_name                                          | Y        | group_vars/database.yml | Y         |
| mysql_users                                    | object  | strapi_db_user                                          | Y        | group_vars/database.yml | Y         |
| nodejs_version                                 | int     | 14                                                      | Y        | group_vars/strapi.yml   | Y         |
| application_dir                                | string  | /srv/deploy/{{ application_name }}                      | Y        | group_vars/strapi.yml   | Y         |
| application_git                                | string  | https://github.com/derrickmehaffy/strapi-deploy-example | Y        | group_vars/strapi.yml   | N         |
| acme_sh_become_user                            | string  | root                                                    | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_git_url                                | string  | https://github.com/acmesh-official/acme.sh              | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_git_version                            | string  | master                                                  | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_upgrade                                | boolean | true                                                    | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_list_domains                           | boolean | true                                                    | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_default_debug                          | boolean | false                                                   | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_default_dns_sleep                      | int     | 120                                                     | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_copy_certs_to_path                     | string  | /etc/nginx/ssl                                          | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_default_dns_provider                   | string  | dns_cf                                                  | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_default_issue_renew_hook               | string  | sudo systemctl reload nginx                             | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_domains                                | object  | application_url                                         | Y        | group_vars/strapi.yml   | Y         |
| acme_sh_default_staging                        | boolean | true                                                    | Y        | group_vars/strapi.yml   | N         |
| acme_sh_default_force_issue                    | boolean | false                                                   | Y        | group_vars/strapi.yml   | N         |
| nginx_remove_default_vhost                     | boolean | true                                                    | Y        | group_vars/strapi.yml   | Y         |
| nginx_client_max_body_size                     | string  | 256m                                                    | Y        | group_vars/strapi.yml   | N         |
| nginx_upstreams                                | object  | See file                                                | Y        | group_vars/strapi.yml   | Y         |
| nginx_vhosts                                   | object  | See file                                                | Y        | group_vars/strapi.yml   | Y         |
| root_ssh_key                                   | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |
| strapi_db_name                                 | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |
| strapi_db_user                                 | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |
| strapi_db_host                                 | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |
| application_name                               | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |
| application_url                                | string  | Based on Terraform Output                               | Y        | tf_vars/tf_vars.yml     | Y         |

### Ansible Instructions

Coming soon

## Other deploy scripts I have created or plan to

- strapi-aws-deploy (Coming soon)
- strapi-digitalocean-deploy (Coming soon)
- strapi-googlecloud-deploy (Coming soon)
- strapi-linode-deploy (Coming soon)
- [strapi-vultr-deploy](https://github.com/derrickmehaffy/strapi-vultr-deploy) (You are here?)

## License

This entire repo is licensed under [MIT](./LICENSE) and you are free to use it as you please. Do keep in mind that this license does not cover any of the Ansible roles/collections specified in the [requirements](./ansible/requirements.yml) file nor any of the Terraform providers.
