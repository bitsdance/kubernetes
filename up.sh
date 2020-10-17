# replace x in 1.19.x-00 with the latest patch version

echo "marking unhold"
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm=$1-00 && \
sudo apt-mark hold kubeadm

read -p "good to go or press cancel ctrl+c"


echo "downloading updated kubeadm"
# since apt-get version 1.1 you can also use the following method
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubeadm=$1-00

read -p "good to go or press cancel ctrl+c"


echo "kubeadm version check"

kubeadm version

read -p "good to go or press cancel ctrl+c"


echo "draining" $2

kubectl drain $2 --ignore-daemonsets

read -p "good to go or press cancel ctrl+c"

echo "upgrade plan"

sudo kubeadm upgrade plan

read -p "good to go or press cancel ctrl+c"

echo "upgrading kubeadm"
sudo kubeadm upgrade apply v$1

read -p "good to go or press cancel ctrl+c"

echo "uncordon" $2
kubectl uncordon $2

read -p "good to go or press cancel ctrl+c"

echo "unhold and update kubelet and kubectl" $1
# replace x in 1.19.x-00 with the latest patch version
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet=$1-00 kubectl=$1-00 && \
sudo apt-mark hold kubelet kubectl

read -p "good to go or press cancel ctrl+c"


echo "upgrading kubelet and kubectl" $1
# since sudo apt-get version 1.1 you can also use the following method
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=$1-00 kubectl=$1-00

read -p "good to go or press cancel ctrl+c"

echo "daemon-reload"
sudo systemctl daemon-reload

read -p "good to go or press cancel ctrl+c"

echo "restart kubelet"
sudo systemctl restart kubelet

echo "done"
read -p "good to go or press cancel ctrl+c"
