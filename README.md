# k8s-platform-lab — Kubernetes Architect Demo
Hands-on multitenancy Kubernetes platform lab demonstrating RBAC, ResourceQuotas, NetworkPolicies, Helm, Terraform (AKS) and monitoring — aligned to Syspro Junior Kubernetes Architect role.
Stack: AKS, Docker, YAML, Helm, Terraform, Prometheus/Grafana concepts, RBAC.
### Architecture
- Terraform provisions AKS with managed AAD RBAC and Log Analytics
- Helm chart deploys `fraud-bot` workload with resource quotas and network policies
- ServiceMonitor for Prometheus scraping
### 1. Quick Start — kubectl
```bash
# Login to Azure
az login
az account set --subscription <your-subscription-id>
# Get kubeconfig (output from terraform)
az aks get-credentials --resource-group rg-fraud-bot-k8s-lab --name aks-fraud-bot-lab
# Verify cluster
kubectl get nodes
kubectl get pods -A
# Create namespaces for multitenancy demo
kubectl create namespace fraud-bot-prod
kubectl create namespace fraud-bot-staging
# Apply core manifests
kubectl apply -f manifests/ -n fraud-bot-prod
# Check deployment
kubectl get pods -n fraud-bot-prod
kubectl get svc -n fraud-bot-prod
kubectl get configmap -n fraud-bot-prod
# Apply Helm chart (recommended)
helm upgrade --install fraud-bot-prod./helm-charts/fraud-bot -n fraud-bot-prod
# Logs and troubleshooting
kubectl logs -l app=fraud-bot -n fraud-bot-prod --tail=100
kubectl describe pod -l app=fraud-bot -n fraud-bot-prod
