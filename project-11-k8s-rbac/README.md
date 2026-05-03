🚀 Project 11: Kubernetes RBAC Implementation
================================================================================================================


📌 Objective

Implement Role-Based Access Control (RBAC) to enforce least-privilege access in a multi-tenant Kubernetes cluster.

🧱 Architecture

Namespaces:
	team-frontend
	team-backend
ServiceAccount:
	backend-sa (team-backend)
Role:
	backend-read-role (read-only pods)
ClusterRole:
	cluster-read-role (nodes, PVs)
Bindings:
	RoleBinding → ServiceAccount
	ClusterRoleBinding → SRE user

===================================================================================================================
⚙️ Implementation Steps

1. Create Namespaces
kubectl apply -f manifests/namespace.yaml

2. Create ServiceAccount
kubectl apply -f manifests/serviceaccounts.yaml

3. Create Role (Least Privilege)
kubectl apply -f manifests/roles.yaml

4. Create ClusterRole
kubectl apply -f manifests/clusterroles.yaml

5. Bind Role to ServiceAccount
kubectl apply -f manifests/rolebindings.yaml

6. Bind ClusterRole (Admin Access)
kubectl apply -f manifests/clusterrolebindings.yaml


🧪 Validation
✅ Allowed Action


kubectl auth can-i get pods \
--as=system:serviceaccount:team-backend:backend-sa \
-n team-backend


❌ Denied Action

kubectl auth can-i delete pods \
--as=system:serviceaccount:team-backend:backend-sa \
-n team-backend

🔍 Audit

kubectl who-can delete pods
kubectl get rolebindings,clusterrolebindings -A


⚠️ Common Issues & Fixes

Issue	Cause	Fix
can-i → no	Wrong subject type	Use ServiceAccount
Forbidden error	Namespace mismatch	Align namespace
No effect	RoleBinding incorrect	Check describe rolebinding

🎯 Key Learnings
	RBAC fundamentals (Role vs ClusterRole)
	ServiceAccount-based access control
	Debugging permission issues
	Multi-tenant isolation
