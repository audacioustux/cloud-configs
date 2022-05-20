#!/bin/bash
set -x

# grow root filesystem if possible
/usr/libexec/oci-growfs -y || true

yum update -y oracle-cloud-agent
systemctl disable firewalld --now

iptables -A INPUT -i ens3 -p tcp  --dport 6443 -j DROP
iptables -I INPUT -i ens3 -p tcp -s 10.0.0.0/8  --dport 6443 -j ACCEPT

public_ip=$(curl -s ifconfig.co)
local_ip=$(curl -s -H "Authorization: Bearer Oracle" -L http://169.254.169.254/opc/v2/vnics/ | jq -r '.[0].privateIp')

wait_lb() {
    while [ true ]
    do
        curl --output /dev/null --silent -k https://$local_ip:6443
        if [[ "$?" -eq 0 ]]; then
            break
        fi
        sleep 5
        echo "wait for LB"
    done
}

curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL=latest K3S_CLUSTER_SECRET='${cluster_token}' sh -s - --cluster-init --node-ip $local_ip --advertise-address $local_ip --write-kubeconfig-mode "0644" --tls-san=$public_ip

cat <<EOF > /etc/rancher/k3s/registries.yaml
mirrors:
  ${container_registry_host}:
    endpoint:
      - "https://${container_registry_host}"
configs:
  "${container_registry_host}":
    auth:
      username: ${container_registry_username}
      password: ${container_registry_password}
EOF

wget https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml -P /var/lib/rancher/k3s/server/manifests

wait_lb

mkdir /home/opc/.kube
cp /etc/rancher/k3s/k3s.yaml /home/opc/.kube/config
sed -i "s/127.0.0.1/$public_ip/g" /home/opc/.kube/config
chown opc:opc /home/opc/.kube/ -R

iptables -D INPUT -i ens3 -p tcp --dport 6443 -j DROP

yum update -y