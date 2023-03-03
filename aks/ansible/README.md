# POC ansible for managed systems

## Prepare

### Setup venv

Setup virtual environment to prevent any conflicting issues with system azure cli, e.g....

```bash
python3 -m venv venv
source venv/bin/activate
pip install ansible "pywinrm>=0.3.0"

ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install ansible.windows

# for login with CLI
pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
```
