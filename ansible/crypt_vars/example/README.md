# Sample encrypted database.yml file

There is a sample database.yml file called `database-encrypted.yml`.

If you set your `vault_password` to `Gh76NXZD/TUkNA0qUSc=` and run `./vault.sh decrypt crypt_vars/example/database-encrypted.yml` you can decrypt the file.

You do not need to decrypt these unless you want to edit the file, running playbooks with the `./run.sh` script will automatically use the vault pass and decrypt safely while running the playbook.

Options for the vault script come from the `ansible-vault` command:

```
usage: ansible-vault [-h] [--version] [-v]
                     {create,decrypt,edit,view,encrypt,encrypt_string,rekey} ...

encryption/decryption utility for Ansible data files

positional arguments:
  {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
    create              Create new vault encrypted file
    decrypt             Decrypt vault encrypted file
    edit                Edit vault encrypted file
    view                View vault encrypted file
    encrypt             Encrypt YAML file
    encrypt_string      Encrypt a string
    rekey               Re-key a vault encrypted file

optional arguments:
  --version             show program's version number, config file location, configured module search
                        path, module location, executable location and exit
  -h, --help            show this help message and exit
  -v, --verbose         verbose mode (-vvv for more, -vvvv to enable connection debugging)

See 'ansible-vault <command> --help' for more information on a specific command.
```
