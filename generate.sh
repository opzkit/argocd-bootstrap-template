#!/usr/bin/env bash

declare -A replacements
replacements[argocd.version]="v2.1.1"
replacements[argocd.host]="argocd.k8s.sparetimecoders.com"
replacements[argocd.applicationset.version]="v0.2.0"
replacements[externaldns.clusterName]="cluster"
replacements[argocd.bootstrap.repoURL]="git@github.com:sparetimecoders/stc-argocd-bootstrap.git"
replacements[argocd.bootstrap.revision]="HEAD"
replacements[dex.github.organisation]="sparetimecoders"
replacements[dex.github.team]="admin"
replacements[dex.github.clientId]="bafc5566e000d81e2322"
replacements[argocd.apps.repoURL]="git@github.com:sparetimecoders/argocd-apps.git"
replacements[argocd.apps.revision]="HEAD"
replacements[github.action.controller.version]="v0.20.1"
replacements[externaldns.version]="v0.9.0"

mkdir -p build
cp -r bootstrap projects kustomization.yaml ./build
for f in $(find ./build -type f); do
  for k in "${!replacements[@]}"; do
    sed -i "s%__${k}__%${replacements[$k]}%g" $f
  done
done
