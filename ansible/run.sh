#!/bin/bash
set -e

ansible-playbook main.yml --vault-password-file=vault_password $@

exit