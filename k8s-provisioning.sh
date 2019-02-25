#!/bin/bash

echo "Installing auxiliary utils..."
apt-get update && apt-get install -y apt-transport-https curl

echo "Adding the Kubernetes's repo key..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Installing the Kubernetes components..."
apt-get update
apt-get install -y kubelet kubeadm kubectl || { echo "Can't install the Kubernetes components! Exiting..."; exit 1; }

echo "Disabling swap in order to run kubelet..."
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab || { echo "Can't disable swap! Exiting..."; exit 1; }

ipaddr=$(ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:)
echo "Configuring Kubelet to run on the private network interface..."
cat > /etc/default/kubelet<<EOF
KUBELET_EXTRA_ARGS=--node-ip=${ipaddr}
EOF


echo "Populating bashrc..."
cat >> $HOME/.bashrc<<EOF
export PATH=\$PATH:/usr/local/bin

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; \$PROMPT_COMMAND"

export HISTFILESIZE=50000
export HISTSIZE=2000
export HISTTIMEFORMAT="%t%d.%m.%y %H:%M:%S%t"
export HISTCONTROL=ignoredups:erasedups

alias c='clear'
alias config_show='e -v '\''(^#|^$|^[[:space:]]+#)'\'''
alias d='dirs -v'
alias dl='docker logs'
alias dps='docker ps'
alias e='egrep --color'

alias gd='git diff'
alias gl='git log'
alias gpom='git push origin master'
alias gs='git status'

alias h='htop'
alias hi='history'
alias i='ip addr'
alias p='pwd'
alias po='popd'
alias pu='pushd'
alias s='set -o vi'
alias show_swap_usage='for file in /proc/*/status ; do awk '\''/VmSwap|Name/{printf \$2 " " \$3}END{ print ""}'\'' \$file; done | sort -k 2 -n -r | less'
alias sy='systemctl '
alias t='top'
alias v='vim'

# show logs for pod-pattern
kl() {
        opts=
        if [[ \${1} == '-f' ]]; then
                    opts=-f
                                shift \$((OPTIND-1))
        fi

        podname=\${1}
        kubectl logs \${opts} \${podname}
}

# get shell in pod
kshp() {
        pod=\${1}
        kubectl exec -it \${pod} bash || { echo "Bash has failed, trying connect with sh..."; kubectl exec -it \${pod} sh; }
}

alias kdp='kubectl describe pod'
alias ktp='kubectl top pods'

alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deploy'
alias kgr='kubectl get rs'
alias kgn='kubectl get nodes'

alias kds='kubectl describe services'
alias kdn='kubectl describe nodes'
alias kdd='kubectl describe deploy'
alias kdr='kubectl describe rs'

alias ktn='kubectl top nodes'
alias krlstdpl='kubectl rollout status deployment'
EOF
