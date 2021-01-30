![strapi + ansible/terraform/vultr](./images/strapi+ansible_terraform_vultr.png)

# Strapi Vultr Deployment with Terraform & Ansible

## WORK IN PROGRESS

## Foreword

Please keep in mind, while I do work for Strapi, all the work of this repo is of a personal nature. This repo is not maintained by Strapi (the company) and there is no guarantee, express or implied that it will be actively maintained. I am producing this project in my free time and will update it when I can.

Issues opened asking for updates or general spam will be closed and ignored. That being said, I openly welcome you to report any issues you find and I'll address them when I can. Naturally I am certainly no Terraform or Ansible pro and I welcome any outside contribution to help out.

## About

This deploy template uses Terraform to configure and deploy two Vultr instances, one for a MariaDB database and one for a Strapi application. It will automatically add an SSH key and create a few service users as well as register the new Strapi instance in Cloudflare. It will also register an SSL Certificate with Let's Encrypt for the subdomain and setup Nginx to reverse proxy Strapi.

## Instructions

Please see the dedicated section in the [Strapi Guru](https://docs.strapi.guru/deploy-guides/vultr/vultr-intro) documentation for information on how to use this template.

## Other deploy scripts I have created or plan to

- strapi-aws-deploy (Coming soon)
- [strapi-digitalocean-deploy](https://github.com/derrickmehaffy/strapi-digitalocean-deploy)
- strapi-gcp-deploy (Coming soon)
- [strapi-linode-deploy](https://github.com/derrickmehaffy/strapi-linode-deploy)
- [strapi-vultr-deploy](https://github.com/derrickmehaffy/strapi-vultr-deploy) (You are here?)

## License

This entire repo is licensed under [MIT](./LICENSE) and you are free to use it as you please. Do keep in mind that this license does not cover any of the Ansible roles/collections specified in the [requirements](./ansible/requirements.yml) file nor any of the Terraform providers.
