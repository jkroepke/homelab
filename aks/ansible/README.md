# POC ansible for managed systems

## Prepare

```
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install ansible.windows

ansible-galaxy collection install keepersecurity.keeper_secrets_manager

# for login with CLI
pip3 -U install azure-cli

# Connection to Windows hosts
pip3 -U install "pywinrm>=0.3.0"


# OPTIONAL: for getting passwords from keeper
pip3 -U install keeper-secrets-manager-cli keeper_secrets_manager_ansible
```
