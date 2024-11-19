# Variables
KUBECTL = kubectl --context kind-kind
ARGOCD = argocd --kube-context kind-kind
KIND = kind
ARGOCD_VERSION = v2.13.0
ARGO_ROLLOUTS_VERSION = v1.7.2

.PHONY: all create-cluster delete-cluster install start stop argo-cd-dashboard pods

all: create-cluster install argo-cd-dashboard rollout-dashboard

create-cluster:
	@echo "Creating a Kind cluster..."
	$(KIND) create cluster --config kind-config.yaml

delete-cluster:
	@echo "Deleting the Kind cluster..."
	$(KIND) delete cluster

install:
	@echo "Installing ArgoCD and Argo Rollouts..."
	$(KUBECTL) create namespace argocd || true
	$(KUBECTL) create namespace argo-rollouts || true
	$(KUBECTL) create namespace test-namespace || true
	$(KUBECTL) apply -n argocd -f https://github.com/argoproj/argo-cd/raw/$(ARGOCD_VERSION)/manifests/install.yaml
	$(KUBECTL) apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/raw/$(ARGO_ROLLOUTS_VERSION)/manifests/install.yaml

pods:
	$(KUBECTL) get pods -A

start: create-cluster install

stop: delete-cluster

argo-cd-dashboard:
	@echo "Fetching ArgoCD admin password..."
	@echo "Visit https://localhost:8080 to login."
	@$(KUBECTL) get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d | xargs -I{} echo "Username: admin Password: {}"
	$(KUBECTL) port-forward svc/argocd-server -n argocd 8080:443

.PHONY: argo-cd-login
argo-cd-login:
	@echo "Logging into ArgoCD..."
	$(ARGOCD) login localhost:8080 --insecure --username admin --password $$(kubectl --context kind-kind get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)

.PHONY: sync-app
sync-app: argo-cd-login
	@echo "Syncing the example application..."
	$(ARGOCD) app sync test-app --local manifests/

.PHONY: create-app
create-app: argo-cd-login
	@echo "Creating an example application..."
	$(ARGOCD) app create test-app --repo https://github.com/zhammer/argocd-degraded-replica --path manifests/ --dest-server https://kubernetes.default.svc --dest-namespace argocd
