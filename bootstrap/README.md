# Bootstrap

This folder contains a [kustomization.yaml](./kustomization.yaml) for setting up

* [ArgoCD] resources
* An [Application] for ArgoCD to manage the ArgoCD installation itself
* An [Application] for managing [cluster resources](./cluster-resources/README.md)
* An [Application] for managing ArgocD [projects] [boostrap](./projects/README.md)


[ArgoCD]: https://argo-cd.readthedocs.io/en/stable
[Application]: https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications
[projects]: https://argo-cd.readthedocs.io/en/stable/user-guide/projects/
