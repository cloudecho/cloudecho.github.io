---
layout: post
title:  "Deploy dashboard on Kubernetes (k8s) v1.22"
date:   2021-08-28 19:29:00 +0800
categories: Opensource
tags:
- k8s
- kubernetes
- dashboard
---

# 1. Install kubectl on control server

## 1.1 Install kubectl

```sh
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg

exclude=kubelet kubeadm kubectl
EOF

yum install -y kubectl --disableexcludes=kubernetes
```

## 1.2 Create `~/.kube/config` file

```sh
mkdir -p ~/.kube
scp echo@master01.k8s:~/.kube/config ~/.kube/config
```

## 1.3 Check the kubectl version

```sh
kubectl version --short
```

*Output:*

```sh
Client Version: v1.22.1
Server Version: v1.22.1
```

# 2. Deploy dashborad

## 2.1 Deploy dashborad

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml
```

*Output:*

```sh
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
Warning: spec.template.metadata.annotations[seccomp.security.alpha.kubernetes.io/pod]: deprecated since v1.19; use the "seccompProfile" field instead
deployment.apps/dashboard-metrics-scraper created
```

## 2.2 Check the pods & services

```sh
kubectl get pod -n kubernetes-dashboard; echo; kubectl get svc -n kubernetes-dashboard 
```

*Output:*

```sh
NAME                                         READY   STATUS    RESTARTS   AGE
dashboard-metrics-scraper-856586f554-tgrhf   1/1     Running   0          5m25s
kubernetes-dashboard-67484c44f6-zzc8m        1/1     Running   0          5m27s

NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
dashboard-metrics-scraper   ClusterIP   10.108.194.211   <none>        8000/TCP   5m29s
kubernetes-dashboard        ClusterIP   10.109.50.222    <none>        443/TCP    5m33s
```

# 3. Expose dashboard using NodePort

## 3.1 Reconfigure `kubernetes-dashboard` servcie

*Reconfigure `kubernetes-dashboard` servcie with fixed nodePort `32700`*

```sh
cat << EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  type: NodePort
  ports:
    - port: 443
      targetPort: 8443
      nodePort: 32700
  selector:
    k8s-app: kubernetes-dashboard
EOF
```

*Output:*

```sh
service/kubernetes-dashboard configured
```

## 3.2 Check the services

```sh
kubectl get svc -n kubernetes-dashboard 
```

*Output:*

```sh
NAME                        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.108.194.211   <none>        8000/TCP        141m
kubernetes-dashboard        NodePort    10.109.50.222    <none>        443:32700/TCP   141m
```

# 4. Create a ServiceAccount

Create a `root` service account `my-dashboard-sa` like this

```sh
# Create the service account in the current namespace 
# (we assume default)
kubectl create serviceaccount my-dashboard-sa
# Give that service account root on the cluster
kubectl create clusterrolebinding my-dashboard-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=default:my-dashboard-sa
```

Get the token in that service account

```sh
# Find the secret that was created to hold the token for the SA
tokenname=`kubectl get secrets | grep my-dashboard-sa-token | awk '{print $1}'`
# Show the contents of the secret to extract the token
kubectl describe secret $tokenname | awk '$1=="token:"{print $2}'
```

# 5. Access the dashboard in a web browser

Now we can visit the dashboard via [`https://master01.k8s:32700/`](https://master01.k8s:32700/) in a web browser.<br>
And put that token in the login screen for authentication.

# Reference

* [Install Kubernetes (k8s) v1.22 Highly Available Clusters on CentOS 7](/opensource/2021/08/26/install-k8s-1.22-ha-clusters-on-centos7.html)
* [docs/tasks/access-application-cluster/web-ui-dashboard/](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)
* [blog.heptio.com/on-securing-the-kubernetes-dashboard](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca)