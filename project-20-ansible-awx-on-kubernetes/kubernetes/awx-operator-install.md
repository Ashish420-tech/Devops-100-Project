# AWX Operator Installation

## Create Namespace

```bash
kubectl apply -f namespace.yaml
```

---

## Install AWX Operator

```bash
kubectl apply -f https://github.com/ansible/awx-operator/releases/latest/download/awx-operator.yaml
```

---

## Verify Pods

```bash
kubectl get pods -n awx
```

---

## Deploy AWX

```bash
kubectl apply -f awx-deployment.yaml
```
