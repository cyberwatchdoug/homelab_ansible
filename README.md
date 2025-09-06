# homelab_ansible

Repository for all ansible automations for my homelab.

## Structure

```
.
├── .gitignore
├── ansible.cfg_example
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
│   ├── bootstrap-ansible-user.yml
│   ├── bootstrap-k3s.yml
│   ├── destroy-k3s.yml
│   ├── paperless-backup-cronjob.yml
│   ├── paperless-backup-playbook-cronjob.yml
│   └── paperless-backup.yml
├── scripts/
│   └── paperless-backup-retention.sh
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
   ansible-playbook playbooks/bootstrap-ansible-user.yml --ask-vault-pass
   ansible-playbook playbooks/bootstrap-k3s.yml --ask-vault-pass
   ansible-playbook playbooks/destroy-k3s.yml --ask-vault-pass
   ansible-playbook playbooks/paperless-backup.yml --ask-vault-pass
   ansible-playbook playbooks/paperless-backup-cronjob.yml --ask-vault-pass
   ansible-playbook playbooks/paperless-backup-playbook-cronjob.yml --ask-vault-pass
   ```

## Playbooks

- **bootstrap-ansible-user.yml**  
  Sets up the `ansible_user` account on all hosts, configures SSH keys, and enables passwordless sudo.

- **bootstrap-k3s.yml**  
  Bootstraps the installation and initial configuration of k3s on Fedora Linux VMs.

- **destroy-k3s.yml**  
  Removes k3s from a Fedora Linux VM, including stopping services and cleaning up files.

- **paperless-backup.yml**  
  Backs up Paperless-NGX, encrypts the backup, and copies it to an SMB share using credentials from vault files.  
  - Supports Fedora, Debian, Ubuntu, and other platforms.
  - Uses vault variables for SMB credentials and backup password.

- **paperless-backup-cronjob.yml**  
  Installs the backup retention script on the OMV server and sets up a cron job and log rotation for automated cleanup of old Paperless-NGX backups.

- **paperless-backup-playbook-cronjob.yml**  
  Sets up a cron job to run the Paperless-NGX backup playbook daily and configures log rotation for the backup logs.

## Scripts

- **paperless-backup-retention.sh**  
  Bash script to remove old Paperless-NGX backup files older than a specified number of days. Used by the backup retention cron job.

## Security

- Vault files containing secrets are ignored by `.gitignore` (except example files).
- Always use encrypted vault files for sensitive data.

## License

This project is licensed under the GNU GPL v3. See [LICENSE](LICENSE) for details.

## Contributing

Feel free to submit issues or pull requests for improvements or additional features.
