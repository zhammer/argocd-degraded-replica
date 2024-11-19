# Local ArgoCD + Argo Rollouts Setup (Kind)

This repository provides an automated way to run ArgoCD and Argo Rollouts locally using Kind and Kubernetes.

## Prerequisites

1. [Kind](https://kind.sigs.k8s.io/)
2. [Kubectl](https://kubernetes.io/docs/tasks/tools/)
3. [ArgoCD CLI](https://github.com/argoproj/argo-cd/releases)
4. [Argo Rollouts CLI](https://github.com/argoproj/argo-rollouts/releases)

## Instructions

1. `make start` (create cluster with argocd & rollouts)
2. `make argo-cd-dashboard` (port forward into argocd, make take a minute to be ready - view output for login & pass)
3. `make create-app` (create argocd app)
4. `make sync-app` (sync the app)

## test-app

The `Application` in this repo (`test-app`), contains two deployables: one a `Rollout` and one a `Deployment`. Each is a simple nginx server with `progressDeadlineSeconds: 60` and `initialDelaySeconds: 90`: for 30 seconds after the progress deadline has exceeded each will be unhealthy. The rollout is a canary with no steps.
