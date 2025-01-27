# Ansible Configuration Settings
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html

export ANSIBLE_VAULT_PASSWORD_FILE="$XDG_CONFIG_HOME/ansible/vault_pass"
export ANSIBLE_SSH_ARGS="-F $HOME/.ssh/ansible-config -o ControlMaster=auto -o ControlPersist=30m -o ConnectionAttempts=100 -o UserKnownHostsFile=/dev/null"
export ANSIBLE_HOME="$XDG_DATA_HOME/ansible"
