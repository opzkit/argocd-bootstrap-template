# ArgoCD
This folder contains the kustomize setup to install [ArgoCD].
It relies on an [ALB Ingress controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller)
to be configured in the Kubernetes cluster.
To use another ingress controller, edit the
[argode-ui-ingress.yaml](./base/argocd-ui-ingress.yaml) file with correct values.




[ArgoCD]: https://argo-cd.readthedocs.io/en/stable
