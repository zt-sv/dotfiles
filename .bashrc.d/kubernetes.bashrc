export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"
export KREW_ROOT="$XDG_DATA_HOME/krew"

_bashrc_add_path $KREW_ROOT/bin;

complete -C /usr/local/bin/kustomize kustomize
