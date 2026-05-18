🚀 Project: Event-Driven Autoscaling with KEDA + AWS SQS
📌 Overview

This project demonstrates event-driven autoscaling in Kubernetes using:

KEDA
Amazon SQS

Unlike traditional autoscaling (HPA), which relies on CPU/memory, this system scales workloads based on SQS queue depth.

🧠 Problem Statement

Traditional autoscaling:

Depends on CPU/memory metrics
Cannot scale to zero
Inefficient for queue-based workloads
✅ Solution

KEDA enables:

No messages → 0 pods
Messages arrive → automatic scaling

👉 This provides cost-efficient, event-driven scaling

⚙️ Architecture
AWS CLI / Producer
        ↓ (SendMessage)
Amazon SQS Queue
        ↓ (Queue Depth)
KEDA
        ↓ (creates HPA internally)
Worker Pods (Kubernetes)
🧩 Components
🔹 Amazon SQS
Managed message queue
Stores jobs/messages
Provides queue depth metric
🔹 KEDA
Monitors SQS queue length
Converts events → metrics
Triggers Kubernetes scaling
🔹 Worker Deployment
Processes queue messages
Starts with 0 replicas
Scales dynamically
🔹 TriggerAuthentication
Connects Kubernetes → AWS
Uses IAM access keys
🔹 ScaledObject (Core)

Defines:

Target deployment
SQS queue trigger
Scaling threshold
📊 Scaling Logic
Queue depth > threshold → scale up
Queue empty → scale down to 0

Example:

Messages	Pods
0	0
10	1–2
50	3–5
🛠️ Implementation Steps
1️⃣ Install KEDA
helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace keda --create-namespace
2️⃣ Create SQS Queue
Go to AWS SQS
Create queue: keda-demo-queue
Copy Queue URL
3️⃣ Create IAM User

Using AWS Identity and Access Management:

Create user with:
AmazonSQSFullAccess
Generate:
Access Key
Secret Key
4️⃣ Create Kubernetes Secret
kubectl create secret generic aws-secret \
  --from-literal=AWS_ACCESS_KEY_ID=<your-key> \
  --from-literal=AWS_SECRET_ACCESS_KEY=<your-secret>
5️⃣ Create TriggerAuthentication
kubectl apply -f - <<EOF
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: aws-auth
spec:
  secretTargetRef:
  - parameter: awsAccessKeyID
    name: aws-secret
    key: AWS_ACCESS_KEY_ID
  - parameter: awsSecretAccessKey
    name: aws-secret
    key: AWS_SECRET_ACCESS_KEY
EOF
6️⃣ Deploy Worker
kubectl apply -f k8s/worker-deployment.yaml
7️⃣ Configure KEDA (SQS)
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: worker-scaler
spec:
  scaleTargetRef:
    name: queue-worker
  minReplicaCount: 0
  maxReplicaCount: 10
  cooldownPeriod: 30
  triggers:
  - type: aws-sqs-queue
    metadata:
      queueURL: <YOUR_SQS_URL>
      awsRegion: ap-south-1
      queueLength: "5"
    authenticationRef:
      name: aws-auth
8️⃣ Apply Configuration
kubectl apply -f k8s/keda-scaledobject.yaml
9️⃣ Send Messages
aws sqs send-message \
  --queue-url <QUEUE_URL> \
  --message-body "test"
🔟 Watch Scaling
kubectl get pods -w
🔥 11. Scale to Zero
aws sqs purge-queue --queue-url <QUEUE_URL>
📈 Observations
🔹 Scale Up
0 → multiple pods
🔹 Event-driven scaling
Based on queue backlog
Not CPU usage
🔹 Scale Down
pods → 0
⚠️ Challenges & Fixes
❌ AccessDenied (SQS)

✔ Fix:

AmazonSQSFullAccess policy
❌ Not scaling to zero

✔ Fix:

minReplicaCount: 0
cooldownPeriod: 30
❌ Queue not empty

✔ Fix:

aws sqs purge-queue
🧠 Key Learnings
KEDA enables event-driven autoscaling
SQS is eventually consistent
Scaling depends on queue backlog
KEDA internally uses HPA
Scale-to-zero is crucial for cost optimization
💡 Real-World Use Cases
Background job processing
Microservices with async workflows
Serverless-like architectures
Queue-driven systems
🔐 Production Considerations
Use IAM Roles (IRSA) instead of access keys
Tune:
queue thresholds
cooldown period
Add monitoring (Prometheus + Grafana)
Use Dead Letter Queues (DLQ)
📁 Project Structure
project-8-keda-autoscaling/
│
├── k8s/
│   ├── worker-deployment.yaml
│   ├── keda-scaledobject.yaml
│
├── load-test/
│
└── README.md
🏁 Conclusion

This project demonstrates a production-ready autoscaling system where workloads scale dynamically based on real-time queue demand.
