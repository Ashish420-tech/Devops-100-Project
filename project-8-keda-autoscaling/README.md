🚀 Project: Event-Driven Autoscaling with KEDA
📌 Overview

This project demonstrates event-driven autoscaling in Kubernetes using KEDA (Kubernetes Event-Driven Autoscaler).

Unlike traditional autoscaling (HPA), which relies on CPU or memory metrics, this system scales workloads based on external events, specifically Redis queue length.

🧠 Problem Statement

Traditional autoscaling approaches:

Depend on CPU/memory usage
Cannot scale to zero
Waste resources during idle periods

This project solves these limitations by:

Scaling pods only when work exists
Scaling down to zero when idle
Reacting to real-time queue demand
⚙️ Architecture
[ Producer Pod ]
        ↓ (LPUSH jobs)
     [ Redis Queue ]
        ↓ (Queue Length > Threshold)
     [ KEDA ]
        ↓ (creates HPA internally)
     [ Worker Pods ]
🧩 Components Explained
1. Redis (Event Source)
Acts as a message queue
Stores incoming jobs
KEDA monitors queue length
2. Producer Pod
Continuously pushes jobs into Redis
Simulates real-world workload (e.g., background jobs)
3. Worker Deployment
Processes jobs from queue
Starts with 0 replicas
Scaled dynamically by KEDA
4. KEDA ScaledObject (Core Logic)

Defines:

Target deployment (queue-worker)
Trigger source (Redis)
Scaling threshold
🔥 Key Feature: Scale-to-Zero

Unlike HPA:

No jobs → No pods → Zero resource usage

When jobs arrive:

Queue increases → Pods scale up instantly
📊 Scaling Logic

KEDA monitors:

Redis Queue Length (LLEN jobs)

Scaling rule:

If queue length > 5 → scale up
If queue empty → scale down to 0
🛠️ Implementation Steps
1. Install KEDA
helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace keda --create-namespace
2. Deploy Redis
kubectl apply -f k8s/redis.yaml
3. Deploy Worker (initial replicas = 0)
kubectl apply -f k8s/worker-deployment.yaml
4. Configure KEDA Scaling
kubectl apply -f k8s/keda-scaledobject.yaml
5. Generate Load
kubectl apply -f load-test/producer.yaml
6. Observe Scaling
kubectl get pods -w
7. Stop Load (Scale-to-Zero)
kubectl delete pod producer
📈 Observations
🔹 Scale Up
0 → 1 → multiple pods

Triggered when:

Queue length exceeds threshold
🔹 Burst Scaling
Multiple pods created simultaneously
Handles sudden workload spikes efficiently
🔹 Scale Down
multiple → 1 → 0 pods

Triggered when:

Queue is empty
⚠️ Challenges Faced & Fixes
❌ Issue: KEDA not triggering

Cause: Incorrect Redis address
Fix:

address: redis.default.svc.cluster.local:6379
❌ Issue: Not scaling to zero

Cause: HPA minReplicas = 1
Fix:

minReplicaCount: 0
cooldownPeriod: 30
❌ Issue: Pods not scaling down

Cause: Queue still had jobs
Fix:

redis-cli DEL jobs
🧠 Key Learnings
KEDA enables event-driven autoscaling
Scaling depends on external system state
KEDA internally creates and manages HPA
Scale-down is delayed due to cooldown/stabilization
Queue-based systems require backlog awareness
💡 Real-World Use Cases
Background job processing systems
Message queues (SQS, Kafka, RabbitMQ)
Event-driven microservices
Cost-optimized serverless-like workloads
🔐 Production Considerations
Use SQS/Kafka instead of Redis
Configure IAM roles (IRSA)
Set proper:
cooldown periods
scaling thresholds
max replicas
Monitor using Prometheus/Grafana
🧪 Commands Reference
# Check queue length
redis-cli LLEN jobs

# Clear queue
redis-cli DEL jobs

# Check KEDA objects
kubectl get scaledobject

# Check HPA created by KEDA
kubectl get hpa
📁 Project Structure
project-8-keda-autoscaling/
│
├── k8s/
│   ├── redis.yaml
│   ├── worker-deployment.yaml
│   ├── keda-scaledobject.yaml
│
├── load-test/
│   └── producer.yaml
│
└── README.md
🏁 Conclusion

This project demonstrates a production-relevant autoscaling pattern where applications scale based on real workload demand rather than system resource usage.

It highlights how modern cloud-native systems achieve:

Efficient resource utilization
Cost optimization
Real-time responsiveness
