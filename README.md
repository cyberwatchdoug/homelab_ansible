# homelab_ansible

Repository for all ansible automations for my homelab.

## Structure

```
````markdown
# homelab_ansible

This repository contains Ansible playbooks and roles for automating homelab tasks such as user bootstrapping, k3s deployment, and Paperless-NGX backups.

## Structure

```
.
├── .gitignore
├── ansible.cfg_example
├── LICENSE
├── README.md
├── requirements.yml
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
├── roles/
│   └── k3s/
│       ├── defaults/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── meta/
│       │   └── main.yml
│       └── tasks/
│           └── main.yml
└── scripts/
    └── paperless-backup-retention.sh
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
   Install requirements:
   ```sh
   ansible-galaxy collection install -r requirements.yml
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

- **bootstrap-ansible-user.yml** — Sets up the `ansible_user` account, SSH keys and sudo.
- **bootstrap-k3s.yml** — Bootstraps k3s using the `roles/k3s` role (intended to run on the control node/localhost in this repo; can be adapted to inventory groups).
- **destroy-k3s.yml** — Uninstalls k3s and cleans up files.
- **paperless-backup.yml** — Backups Paperless-NGX and copies encrypted backups to SMB using vault-provided credentials.
- **paperless-backup-cronjob.yml** — Installs backup retention script and cron job on OMV server.
- **paperless-backup-playbook-cronjob.yml** — Installs a cron job to run the backup playbook daily.

## Roles

The `roles/k3s` role contains the installation and configuration logic for k3s. Keep role logic idempotent and avoid piping remote scripts directly where possible (this role stages the installer script before execution).

## CI and Linting

A GitHub Actions workflow (`.github/workflows/ansible-lint.yml`) runs `ansible-lint` on pushes and PRs. Run `ansible-lint` locally:

```bash
ansible-lint
```

## Notes & Recommendations

- Prefer roles for reusable logic and keep playbooks concise.
- Use `ansible-galaxy` `requirements.yml` to declare collections.
- Add `molecule` tests for role-level validation if you plan to iterate frequently.

## License

This project is licensed under the GNU GPL v3. See `LICENSE` for details.
