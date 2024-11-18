# Variables
KUBECTL = kubectl --context kind-kind
ARGOCD = argocd --kube-context kind-kind
KIND = kind
ARGOCD_VERSION = v2.8.0
ARGO_ROLLOUTS_VERSION = v1.6.0

.PHONY: all create-cluster delete-cluster install start stop argo-cd-dashboard pods

all: create-cluster install argo-cd-dashboard rollout-dashboard

manifests/installs/argo-rollouts-install.yml:
	curl -sSL -o manifests/installs/argo-rollouts-install.yml https://raw.githubusercontent.com/argoproj/argo-rollouts/stable/manifests/installs/install.yaml

manifests/installs/argo-cd-install.yml:
	curl -sSL -o manifests/installs/argo-cd-install.yml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/installs/install.yaml

create-cluster:
	@echo "Creating a Kind cluster..."
	$(KIND) create cluster --config kind-config.yaml

delete-cluster:
	@echo "Deleting the Kind cluster..."
	$(KIND) delete cluster

install: manifests/installs/argo-rollouts-install.yml manifests/installs/argo-cd-install.yml
	@echo "Installing ArgoCD and Argo Rollouts..."
	$(KUBECTL) apply -f manifests/installs/

pods:
	$(KUBECTL) get pods -A

start: create-cluster install

stop: delete-cluster

argo-cd-dashboard:
	@echo "Fetching ArgoCD admin password..."
	@echo "Visit https://localhost:8080 to login."
	@$(KUBECTL) get secret argocd-initial-admin-secret -n default -o jsonpath="{.data.password}" | base64 -d | xargs -I{} echo "Username: admin Password: {}"
	$(KUBECTL) port-forward svc/argocd-server -n default 8080:443

.PHONY: argo-cd-login
argo-cd-login:
	@echo "Logging into ArgoCD..."
	$(ARGOCD) login localhost:8080 --username admin --password $$(kubectl --context kind-kind get secret argocd-initial-admin-secret -n default -o jsonpath="{.data.password}" | base64 -d)

.PHONY: sync-app
sync-app: argo-cd-login
	@echo "Syncing the example application..."
	$(ARGOCD) app sync test-app --local manifests/test-app/app.yml

.PHONY: create-app
create-app:
	@echo "Creating an example application..."
	$(ARGOCD) app create test-app --repo https://github.com/seatgeek/node-hcl --path manifests/test-app --dest-server https://kubernetes.default.svc --dest-namespace default
