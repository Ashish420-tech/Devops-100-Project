# 🚀 ELK Stack Log Aggregation on Kubernetes

## 📌 Project Overview

This project demonstrates a **production-style centralized logging system** using the ELK Stack deployed on Kubernetes.

It collects logs from all containers using Filebeat and stores them in Elasticsearch, with visualization in Kibana.

---

## 🏗️ Architecture

```
Kubernetes Pods → Filebeat (DaemonSet) → Elasticsearch → Kibana
```

---

## 🔧 Tech Stack

* Kubernetes (Minikube)
* Elasticsearch (ECK Operator)
* Kibana
* Filebeat
* Docker
* Linux

---

## ⚙️ Implementation Steps

### 1️⃣ Deploy ECK Operator

```bash
kubectl apply -f https://download.elastic.co/downloads/eck/2.12.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.12.0/operator.yaml
```

---

### 2️⃣ Deploy Elasticsearch Cluster

* 3-node cluster
* Persistent storage

```yaml
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: devops-es
spec:
  version: 8.12.0
  nodeSets:
  - name: default
    count: 3
    volumeClaimTemplates:
    - metadata:
        name: elasticsearch-data
      spec:
        resources:
          requests:
            storage: 10Gi
```

---

### 3️⃣ Deploy Kibana

```yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: devops-kibana
spec:
  version: 8.12.0
  count: 1
  elasticsearchRef:
    name: devops-es
```

---

### 4️⃣ Deploy Filebeat (DaemonSet)

* Collects logs from:

  ```
  /var/log/containers/*.log
  ```
* Sends logs to Elasticsearch

---

## 🚨 Challenges & Fixes

### 🔹 Filebeat CrashLoopBackOff

* Cause: Missing Elasticsearch authentication
* Fix: Added correct username/password in config

---

### 🔹 No Logs in Kibana

* Cause: Filebeat not reading host logs
* Fix: Added volume mounts to `/var/log`

---

### 🔹 DNS Resolution Issue

* Cause: Cross-namespace service access
* Fix:

```
devops-es-es-http.default.svc.cluster.local
```

---

### 🔹 TLS Certificate Error

* Cause: Self-signed certificates in ECK
* Fix: Disabled strict SSL verification in Filebeat

---

## 📊 Output

* Centralized logs from all Kubernetes pods
* Real-time log visualization in Kibana
* Searchable logs using Discover

---

## 📸 Screenshots

### 🔍 Logs in Kibana Discover

![Discover Logs](screenshots/discover.png)

### 📊 Dashboard View

![Dashboard](screenshots/dashboard.png)

---

## 🧠 Key Learnings

* Debugging is the core of DevOps, not just setup
* Importance of Kubernetes networking & DNS
* Handling TLS in internal services
* Log ingestion pipeline troubleshooting

---

## 💼 Resume Highlights

* Implemented centralized logging using ELK Stack on Kubernetes
* Deployed Filebeat DaemonSet for container log collection
* Debugged DNS, TLS, and log ingestion issues
* Built real-time log monitoring dashboards

---

## 🔗 Future Improvements

* Add Logstash for advanced parsing
* Set up alerting in Kibana
* Integrate with Slack/Email notifications

---

## 📌 Author

Ashish Mondal
DevOps Enthusiast 🚀
