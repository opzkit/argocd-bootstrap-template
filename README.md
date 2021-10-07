# ArgoCD Bootstrap template
Used to generate a git repository for an [ArgoCD] installation.
It's inspired by [Manage Argo CD Using Argo CD] and [ArgoCD Autopilot]

## Usage

1. Create a new Github repository for ArgoCD bootstrap
2. Create a new Github repository for ArgoCD applications
3. Edit [generate.sh](./generate.sh) with correct values and then run it
4. Copy the `build` folder's content to the root of your `ArgoCD bootstrap` repo,
commit and push
5. Bootstrap your Kubernetes cluster with [ArgoCD], see [Bootstrap Kubernetes cluster](#Bootstrap Kubernetes cluster)

## What is installed in the cluster
* [ArgoCD]
* ArgoCD [ApplicationSetController]
* [External DNS](https://github.com/kubernetes-sigs/external-dns)
* [Github Actions Runner](https://github.com/actions-runner-controller/actions-runner-controller)
* [Fluent](https://docs.fluentd.org/v/0.12/articles/kubernetes-fluentd)


### Variables
| Name            | Description     |
  |:----------------|--------------:|
| argocd.version                    | Version of ArgoCD to use |
| argocd.applicationset.version     | Version of [ApplicationSetController] to use |
| argocd.host                       | The DNS name to the installation of ArgoCD, for example argocd.sparetimecoders.com |
| dex.github.clientId               | The [OAuth] application clientID |
| dex.github.organisation           | The Github Organisation for the [OAuth] app |
| dex.github.team                   | The Github team to allow access, read more [here][RBAC] |
| argocd.bootstrap.repoURL          | URL to this repository |
| argocd.bootstrap.revision         | Branch/commit/tag to use |
| argocd.apps.repoURL               | URL to the ArgoCD Applications repository|
| argocd.apps.revision              | Branch/commit/tag to use |
| externaldns.clusterName           | The name of the kubernetes cluster, used to manage DNS records with [External-DNS](./bootstrap/cluster-resources/in-cluster/external-dns/README.md)|
| externaldns.version               | External DNS version to use, see above |
| github.action.controller.version  | [Github Action runners](./bootstrap/cluster-resources/in-cluster/github-runners/README.md) version to use |

# Bootstrap Kubernetes cluster

Some "external" setup is needed since we don't want to store secrets in the Github repository.

## ArgoCD

````yaml
apiVersion: v1
data:
  dex.github.clientSecret: --OAuth application secret--
kind: Secret
metadata:
  labels:
    app.kubernetes.io/instance: argocd
    app.kubernetes.io/name: argocd-secret
    app.kubernetes.io/part-of: argocd
  name: argocd-secret
  namespace: argocd
type: Opaque
---

apiVersion: v1
data:
  sshPrivateKey: --the private key to use for SSH access to Github repositories--
kind: Secret
metadata:
  name: githubsecret
  namespace: argocd
type: Opaque
````
## Github runner's
Some configuration is needed for Github runners

### Configmaps

Configuration for [buildtools](https://buildtools.io/config/config/):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: buildtools
  namespace: github-runners
data:
  .buildtools.yaml: |-
    registry:
      ecr:
        url: 292662267961.dkr.ecr.eu-west-1.amazonaws.com

    targets:
      local:
        context: docker-desktop
        namespace: default
      test:
        context: stc-test.k8s.local

    gitops:
      local:
        url: git@github.com:sparetimecoders/argocd-apps.git
        path: apps/local/argocd-test
```

Optioanl Git configuration for [buildtools](https://buildtools.io/config/gitops/):

````yaml
apiVersion: v1
data:
  .gitconfig: |-
    [user]
      name = Gitops commiter
      email = gitops@buildtools.io
kind: ConfigMap
metadata:
  name: gitconfig
  namespace: github-runners
````
### Secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: controller-manager
  namespace: actions-runner-system
type: Opaque
data:
  github_app_id: --the Githab App Id--
  github_app_installation_id: --the installation id for the Githab App on the organization--
  github_app_private_key: --the private key for the Githab App--
  ```


```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ssh-secret
  namespace: github-runners
type: Opaque
data:
  id_rsa: --the private key used to clone GIT repositories--
  known_hosts: --content of a known_hosts file--
  ```


# TODOs
* Cleanup docs
* Copy some of the contents of this file to `build`?
* Application of Applications for cluster-resources
* Example of setting it up

[ArgoCD]: https://argo-cd.readthedocs.io/en/stable
[Manage Argo CD Using Argo CD]: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#manage-argo-cd-using-argo-cd
[ArgoCD Autopilot]: https://argocd-autopilot.readthedocs.io/en/stable/
[OAuth]: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#dex
[RBAC]: https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/
[ApplicationSetController]: https://github.com/argoproj-labs/applicationset
