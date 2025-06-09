---
layout: post
title:  "Create a self-hosted helm chart and deploy it to kubernetes (v1.22)"
date:   2021-09-04 11:07:00 +0800
categories: Opensource
tags:
- k8s
- kubernetes
- cloudnative
- helm
- chart
---


## 1. Concepts

Here are the descriptions from [helm.sh](https://helm.sh/docs/intro/using_helm/):

> A `Chart` is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.

> A `Repository` is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.

> A `Release` is an instance of a chart running in a Kubernetes cluster. One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

> `Helm` installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.

## 2. Install kubectl & helm

### 2.1 Install kubectl

See [install-kubectl-on-control-server](/OPENSOURCE/2021-08-28-deploy-dashboard-on-k8s-1.22/#1-install-kubectl-on-control-server) .

### 2.2 Install helm

*See [github.com/helm/helm/releases](https://github.com/helm/helm/releases) for helm releases.*

For linux amd64 server:

```sh
wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
tar -zxvf helm-v3.6.3-linux-amd64.tar.gz 
sudo mv linux-amd64/helm  /usr/local/bin/helm 
```

For macOS:

```
brew install helm
```

Check version

```sh
helm version
```

*Output:*

```sh
version.BuildInfo{Version:"v3.6.3", GitCommit:"d506314abfb5d21419df8c7e7e68012379db2354", GitTreeState:"clean", GoVersion:"go1.16.5"}
```

## 3. Create a helm chart

To get started with a new chart, the best way is to use `helm create` command to initialize a new chart.

The following command create a chart named `hello`:


```sh
helm create hello
```

Let's take a look at the file structure of this chart by using `tree -a hello` command:

```
hello
├── .helmignore
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

Now we can continue to complete this chart by editing the files above or adding some other files (such as template file or `README.md` etc.).

See [the-chart-file-structure](https://helm.sh/docs/topics/charts/#the-chart-file-structure) for more information about the chart file structure.

See [charts/hello](https://github.com/cloudecho/charts/tree/main/charts/hello) for more information about this example chart.

By now, we can:

* Locally render templates by using `helm template ./hello`
* Deploy the example chart by using `helm install my-hello-1 ./hello`
* And test the connection by using `helm test my-hello-1`

But we can go further:

* Add `README.md` for a chart
* Package a chart
* Host charts by creating a chart repository
* Publish a chart repository to artifacthub.io

## 4. Host helm charts using Github Page

### 4.1 Create a github repo for helm charts

First let's create a empty repo on Github, for example, named `charts`, take `main` as the default branch.

And clone it to your local server. 

```sh
git clone git@github.com:<YOUR_GITHUB_USERNAME>/charts.git

cd charts
```

Then create a directory named `charts` under the root path of this repo, place chart `hello` under the new created directory. 
Also create `LICENSE` and `README.md` files as you wish.
By now the file structure of the repo like below:

```
.
├── LICENSE
├── README.md
└── charts
    └── hello
        ├── .helmignore    
        ├── Chart.yaml
        ├── templates
        │   ├── NOTES.txt
        │   ├── _helpers.tpl
        │   ├── deployment.yaml
        │   ├── hpa.yaml
        │   ├── ingress.yaml
        │   ├── service.yaml
        │   ├── serviceaccount.yaml
        │   └── tests
        │       └── test-connection.yaml
        └── values.yaml
```

### 4.2 Prepare for creating `README.md` for a chart

There is a tool named [`chart-doc-gen`](https://github.com/kubepack/chart-doc-gen) used for generating `README.md` for a chart.

First let's create a file named `doc.yml` and place it to `charts/hello` directory. 

e.g. 

```yaml
project:
  name: Hello World
  shortName: Hello
  url: https://github.com/cloudecho/hello-world-go
  description: A hello-world program written in go lang.
  app: hello
repository:
  url: https://cloudecho.github.io/charts/
  name: cloudecho
chart:
  name: hello
  version: 0.1.0
  values: "-- generate from values file --"
  valuesExample: "-- generate from values file --"
prerequisites:
- "Kubernetes v1.14+"

release:
  name: my-hello
  namespace: default
```

Then append the text `doc.yml` into `charts/hello/.helmignore` file to avoid `doc.yml` to be packaged. 

Download the latest `chart-doc-gen` from [github.com/kubepack/chart-doc-gen/releases](https://github.com/kubepack/chart-doc-gen/releases) and install it (e.g. copy it to `/usr/local/bin/`).


### 4.3 Create `gh-pages` branch for Github Page

Create `gh-pages` branch and simultaneously switch to that branch.

```sh
git checkout -b gh-pages
```

Merge branch `main` into `gh-pages`:

```sh
git merge main
```

Now we can use `chart-doc-gen` to generate `README.md` file for chart `hello`:

```sh
cd charts

chart-doc-gen \
	-d=hello/doc.yml \
	-v=hello/values.yaml \
	> hello/README.md

cd ..  
```

### 4.4 Package and index helm charts

Use the following command to package `hello` chart and index all the charts: 

```sh
helm package charts/hello
helm repo index . --url https://<YOUR_GITHUB_USERNAME>.github.io/charts/
```

Check the chart package file (`hello-0.1.0.tgz`) and `index.yaml` file by using `tree -L 1` :

```
.
├── LICENSE
├── README.md
├── charts
├── hello-0.1.0.tgz
└── index.yaml
```

We can also:

* check the content of `index.xml` by using `cat index.yml` command.
* check the content of `hello-0.1.0.tgz` by using `tar -tvf hello-0.1.0.tgz` command.


### 4.5 Make it simple by creating a Makefile

Here are some works to update the repo for charts:

1. On `main` branch:
- editing existing chart, e.g. `charts/hello`
- creating new chart, e.g. `helm create charts/another-chart`
- edit `doc.yml`/`.helmignore`

2. Merge branch `main` into `gh-pages`

3. On `gh-pages` branch:
- generationg `README.md` file for each chart
- package each chart
- index all the charts


Let's create a `Makefile` file on `gh-pages` branch to simplify some works above (point 2-3: merge, doc, package and index),
then we can do those works by using a single `make` command:

e.g. 

```Makefile
CHARTS=$(shell ls charts)

default: index

merge:
	GIT_MERGE_AUTOEDIT=no git merge main

doc: 
	$(foreach c, $(CHARTS), chart-doc-gen \
	  -d=charts/$(c)/doc.yml \
	  -v=charts/$(c)/values.yaml \
	  > charts/$(c)/README.md)
	
package: merge doc
	$(foreach c, $(CHARTS), helm package charts/$(c))

index: package
	helm repo index . --url https://cloudecho.github.io/charts/
```

See [cloudecho/charts](https://github.com/cloudecho/charts/) for more information about this example.


### 4.6 Settings for chart repository on Github site

After pushing all the changes to remote git server (github site), 
let's have a look at the settings for chart repository on Github site.

Open a web browser, go to 
https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_GITREPO_FOR_CARTS>/settings/pages

* Select `gh-pages` branch and `/(root)` directory as the source.
* (suggesstion) Make `Enforce HTTPS` checked. 

```
Source
Branch: gh-pages /(root)

[x] Enforce HTTPS 
```

Please refer to [docs.github.com/en/pages](https://docs.github.com/en/pages) for more information about Github Page.

## 5. Publish helm charts to artifacthub.io

This is optional but very convenient for opensource charts as helping people to search and find your charts.

Here are the steps:

* Go to https://artifacthub.io/ in a web browser
* Sign in, for example, with Github
* Go to the `Control Panel/Repositories` ([artifacthub.io/control-panel/repositories](https://artifacthub.io/control-panel/repositories) )
* Click the `ADD` button on the right, select `Helm charts` as the kind, input the `Name` and `Url`, for example

```
Kind
Helm charts

Name
<YOUR_GITHUB_USERNAME>

Url
https://<YOUR_GITHUB_USERNAME>.github.io/charts/
```

* Click the `ADD` button on the bottom to complete.

Now we'll get an `ID` for this chart repository. 

To tell Artifact Hub that you're the owner of this chart repository, 
create a file named `artifacthub-repo.yml` 
and place it to the root path of the github repo for charts.

The content of the file is like this:

```yaml
# Artifact Hub repository metadata file
#
# Some settings like the verified publisher flag or the ignored packages won't
# be applied until the next time the repository is processed. Please keep in
# mind that the repository won't be processed if it has not changed since the
# last time it was processed. Depending on the repository kind, this is checked
# in a different way. For Helm http based repositories, we consider it has
# changed if the `index.yaml` file changes. For git based repositories, it does
# when the hash of the last commit in the branch you set up changes. This does
# NOT apply to ownership claim operations, which are processed immediately.
#
repositoryID: <repositoryid_from_artifacthub>
owners: # (optional, used to claim repository ownership)
  - name: <your_username>
    email: <your_email>
```

Once the chart repositry is processed by Artifact Hub, we can search our charts on the site.

Also We can use `helm search hub xxx` command to search our charts. 

e.g.

```
helm search hub hello
```

## 6. Deploy a chart into kubernetes

As an example, let's follow the [instruction of `hello` chart](https://artifacthub.io/packages/helm/cloudecho/hello) to deploy `hello` chart to an existing kubernetes.

First, add a chart repo:

```
helm repo add cloudecho https://cloudecho.github.io/charts/
helm repo update
helm install my-hello cloudecho/hello -n default --version=0.1.0
```

Here is the *Output*:

```
NAME: my-hello
LAST DEPLOYED: Sat Sep  4 10:20:28 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=hello,app.kubernetes.io/instance=my-hello" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

After running those commands above (`NOTES/1`):

```
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

Open another terminal, and input `curl localhost:8080` command:

```
Hello, World!
2021-09-04 02:28:56.8191115 +0000 UTC
```


## Reference

* [helm.sh/docs/intro/quickstart](https://helm.sh/docs/intro/quickstart/)
* [helm.sh/docs/intro/using_helm/](https://helm.sh/docs/intro/using_helm/)
* [helm.sh/docs/topics/charts](https://helm.sh/docs/topics/charts)
* [helm.sh/docs/topics/chart_repository/#store-charts-in-your-chart-repository](https://helm.sh/docs/topics/chart_repository/#store-charts-in-your-chart-repository)
* [github.com/kubepack/chart-doc-gen](https://github.com/kubepack/chart-doc-gen)
