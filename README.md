# Strapi Vultr Deployment with Terraform & Ansible

**WORK IN PROGRESS** 

## Foreword

Please keep in mind, while I do work for Strapi, all the work of this repo is of a personal nature. This repo is not maintained by Strapi (the company) and there is no guarantee, express or implied that it will be actively maintained. I am producing this project in my free time and will update it when I can.

Issues opened asking for updates or general spam will be closed and ignored. That being said, I openly welcome you to report any issues you find and I'll address them when I can. Naturally I am certainly no Terraform or Ansible pro and I welcome any outside contribution to help out.

## About

## Terraform

### T-Requirements

- Vultr API Key
- Generated an SSH Key

### Variables

Vultr API Key via Shell: `export VULTR_API_KEY="yourKeyHere"`

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
