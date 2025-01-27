# Terraform CLI Configuration
# https://developer.hashicorp.com/terraform/cli/config/config-file

export TF_CLI_CONFIG_FILE="$XDG_CONFIG_HOME/terraform/config.tfrc"
export TF_PLUGIN_CACHE_DIR="$XDG_CACHE_HOME/terraform"

complete -C /usr/local/bin/terraform terraform
