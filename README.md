# homelab_ansible

Repository for all ansible automations for my homelab.

## Structure

```
.
├── .gitignore
├── ansible.cfg
├── LICENSE
├── README.md
├── inventories/
│   ├── hosts.yml
│   ├── group_vars/
│   │   ├── all/
│   │   │   └── example-smb_vault.yml
│   │   └── paperless/
│   │       └── example-paperless_vault.yml
│   └── host_vars/
├── playbooks/
│   ├── bootstrap.yml
│   └── paperless-backup.yml
```

## Getting Started

1. **Install Ansible**  
   On Fedora:  
   ```sh
   sudo dnf install ansible
   ```
   On Ubuntu/Debian:  
   ```sh
   sudo apt install ansible
   ```

2. **Configure Inventory**  
   Edit `inventories/hosts.yml` to match your hosts and groups.

3. **Vault Usage**  
   Sensitive variables (e.g., SMB credentials, backup passwords) should be stored in vault files:
   - Place vault files in `inventories/group_vars/all/` or `inventories/group_vars/paperless/`.
   - Example vault files are provided (`example-smb_vault.yml`, `example-paperless_vault.yml`).
   - Actual vault files should be encrypted using `ansible-vault` and are ignored by `.gitignore`.

   To create a vault file:
   ```sh
   ansible-vault create inventories/group_vars/all/smb_vault.yml
   ```

   To edit a vault file:
   ```sh
   ansible-vault edit inventories/group_vars/all/smb_vault.yml
   ```

4. **Running Playbooks**  
   Run playbooks with vault password prompt:
   ```sh
   ansible-playbook playbooks/bootstrap.yml --ask-vault-pass
   ansible-playbook playbooks/paperless-backup.yml --ask-vault-pass
   ```

## Playbooks

- **bootstrap.yml**  
  Sets up the `ansible_user` account on all hosts, configures SSH keys, and enables passwordless sudo.

- **paperless-backup.yml**  
  Backs up Paperless-NGX, encrypts the backup, and copies it to an SMB share using credentials from vault files.  
  - Supports Fedora, Debian, Ubuntu, and other platforms.
  - Uses vault variables for SMB credentials and backup password.

## Security

- Vault files containing secrets are ignored by `.gitignore` (except example files).
- Always use encrypted vault files for sensitive data.

## License

This project is licensed under the GNU GPL v3. See [LICENSE](LICENSE) for details.

## Contributing

Feel free to submit issues or pull requests for
