# Local ArgoCD + Argo Rollouts Setup (Kind)

This repository provides an automated way to run ArgoCD and Argo Rollouts locally using Kind and Kubernetes.

## Prerequisites

1. [Kind](https://kind.sigs.k8s.io/)
2. [Kubectl](https://kubernetes.io/docs/tasks/tools/)
3. [ArgoCD CLI](https://github.com/argoproj/argo-cd/releases)
4. [Argo Rollouts CLI](https://github.com/argoproj/argo-rollouts/releases)

## Quick Start

1. **Create a Kind Cluster:**
   ```bash
   make create-cluster
   ```

2. **Install ArgoCD and Argo Rollouts:**
   ```bash
   make install
   ```

3. **Login to ArgoCD:**
   ```bash
   make argocd-login
   ```
   Access the ArgoCD dashboard at [https://localhost:8080](https://localhost:8080).

4. **Launch the Argo Rollouts Dashboard:**
   ```bash
   make rollout-dashboard
   ```

5. **Stop and Delete the Cluster:**
   ```bash
   make stop
   ```

## Directory Structure

- `manifests/`: Kubernetes manifests for ArgoCD and Argo Rollouts.
- `kind-config.yaml`: Configuration for Kind.
- `Makefile`: Automates common tasks.

## Customization

You can modify the manifests under `manifests/` to suit your requirements.

## Troubleshooting

If you encounter issues, verify the cluster state:
```bash
make pods
```
