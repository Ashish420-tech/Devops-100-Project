🚀 Kubernetes HPA Autoscaling Project
📌 Overview

This project demonstrates Kubernetes Horizontal Pod Autoscaling (HPA) based on CPU utilization.



🧱 Architecture
Deployment (CPU-bound container)
Service (NodePort)
Metrics Server
HPA Controller
⚙️ Setup
minikube start
minikube addons enable metrics-server
kubectl apply -f k8s/



📊 Verify Metrics
kubectl top nodes
kubectl top pods
🚀 Trigger Scaling
kubectl get hpa -w
kubectl get pods -w



🔥 Results
CPU utilization exceeded 400%
Pods scaled from 1 → 10 automatically
🧠 Key Learnings
HPA depends on metrics-server
CPU requests are mandatory
Load behavior affects scaling
Debugging metrics is critical
