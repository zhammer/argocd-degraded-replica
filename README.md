# Local ArgoCD + Argo Rollouts Setup (Kind)

This repository provides an automated way to run ArgoCD and Argo Rollouts locally using Kind and Kubernetes.

## Prerequisites

1. [Kind](https://kind.sigs.k8s.io/)
2. [Kubectl](https://kubernetes.io/docs/tasks/tools/)
3. [ArgoCD CLI](https://github.com/argoproj/argo-cd/releases)
4. [Argo Rollouts CLI](https://github.com/argoproj/argo-rollouts/releases)

## Instructions

1. `make start`
   1. This creates the kind cluster with argocd on it
2. `make argo-cd-dashboard`
3. `make create-app`
4. `make sync-app`
