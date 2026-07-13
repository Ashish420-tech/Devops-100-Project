# 🚀 Project 30 - Linux Monitoring Dashboard using Prometheus, Grafana & Node Exporter

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

# 📌 Project Overview

This project demonstrates a complete Linux monitoring solution using **Prometheus**, **Grafana**, and **Node Exporter** running with **Docker Compose**.

The monitoring stack collects real-time Linux server metrics, stores them in Prometheus, and visualizes them through interactive Grafana dashboards.

This project is designed as part of my **DevOps 100 Projects Series** to gain hands-on experience in Infrastructure Monitoring and Observability.

---

# 🏗 Architecture

```

+---------------------------+
| Linux Server |
+------------+--------------+
|
|
v
+---------------------------+
| Node Exporter |
| Port : 9100 |
+------------+--------------+
|
| Metrics
|
v
+---------------------------+
| Prometheus |
| Port : 9090 |
+------------+--------------+
|
| Query
|
v
+---------------------------+
| Grafana |
| Port : 3001 |
+---------------------------+
🛠 Tech Stack
Docker
Docker Compose
Prometheus
Grafana
Node Exporter
Linux (Ubuntu)
📂 Project Structure
project-30-linux-monitoring-dashboard
│
├── docker-compose.yml
├── README.md
│
├── prometheus
│   └── prometheus.yml
│
├── grafana
│   ├── dashboards
│   └── provisioning
│
└── screenshots
    ├── grafana-dashboard.png
    ├── prometheus-targets.png
    ├── cpu-dashboard.png
    ├── memory-dashboard.png
    ├── network-dashboard.png
    └── node-exporter-metrics.png
⚙ Components
Prometheus
Collects metrics from Node Exporter
Stores time-series metrics
Executes PromQL queries
Node Exporter

Exports Linux host metrics including:

CPU Usage
Memory Usage
Disk Usage
Filesystem
Network Statistics
Load Average
Uptime
Grafana

Provides visualization dashboards including:

CPU Usage
Memory Utilization
Disk Usage
Network Traffic
Filesystem Usage
System Load
Uptime
🚀 Getting Started
Clone Repository
git clone https://github.com/Ashish420-tech/Devops-100-Project.git
Navigate to Project
cd project-30-linux-monitoring-dashboard
Start Monitoring Stack
docker compose up -d
Verify Containers
docker ps

Expected Containers

Prometheus
Grafana
Node Exporter
🌐 Access URLs
Service	URL
Grafana	http://localhost:3001
Prometheus	http://localhost:9090
Node Exporter	http://localhost:9100/metrics
🔐 Grafana Login

Default credentials

Username : admin
Password : admin
📊 PromQL Examples
CPU Metrics
node_cpu_seconds_total
Memory
node_memory_MemAvailable_bytes
Filesystem
node_filesystem_avail_bytes
Network
node_network_receive_bytes_total
📸 Screenshots
Grafana Dashboard

Prometheus Targets

CPU Dashboard

Memory Dashboard

Network Dashboard

📈 Features
Linux Monitoring
Real-Time Metrics
CPU Monitoring
Memory Monitoring
Disk Monitoring
Filesystem Monitoring
Network Monitoring
Docker Compose Deployment
Prometheus Integration
Grafana Visualization
🧠 Skills Demonstrated
Linux Administration
Docker
Docker Compose
Prometheus
Grafana
Infrastructure Monitoring
Observability
PromQL
DevOps
🚀 Future Enhancements
Alertmanager Integration
Email Alerts
Slack Notifications
cAdvisor for Docker Monitoring
Loki for Centralized Logging
Promtail Integration
Blackbox Exporter
Nginx Monitoring
MySQL Monitoring
Kubernetes Monitoring
📚 Learning Outcomes

Through this project I learned:

Deploying monitoring stacks using Docker Compose
Configuring Prometheus scrape jobs
Integrating Grafana with Prometheus
Monitoring Linux servers
Writing PromQL queries
Visualizing infrastructure metrics
👨‍💻 Author

Ashish Mondal

DevOps | Cloud | Kubernetes | AWS | Terraform | Docker | Linux

GitHub:

https://github.com/Ashish420-tech

⭐ If you found this project useful, consider giving it a Star.
