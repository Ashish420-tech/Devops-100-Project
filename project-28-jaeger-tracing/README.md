# 🚀 Project 28: Distributed Tracing with Jaeger & OpenTelemetry

## 📌 Overview

This project demonstrates **end-to-end distributed tracing** using:

* **OpenTelemetry** for instrumentation
* **Jaeger** for trace visualization
* **Node.js (Express)** microservices

The goal is to track a request as it flows across services and identify latency bottlenecks.

---

## 🏗 Architecture

```
Client → payment-service (Service A)
                ↓
           service-b (Service B)
                ↓
             Jaeger UI
```

---

## 🛠 Tech Stack

* Node.js (Express)
* OpenTelemetry SDK
* Jaeger (all-in-one)
* Axios (HTTP calls)
* Docker

---

## ⚙️ Setup Instructions

### 1️⃣ Clone Repository

```bash
git clone https://github.com/<your-username>/Devops-100-Project.git
cd project-28-jaeger-tracing
```

---

### 2️⃣ Install Dependencies

```bash
npm install
npm install axios
```

---

### 3️⃣ Start Jaeger

```bash
docker run -d --name jaeger \
  -p 16686:16686 \
  -p 4318:4318 \
  jaegertracing/all-in-one:latest
```

👉 Access UI: http://localhost:16686

---

### 4️⃣ Start Service B

```bash
cd service-b
OTEL_SERVICE_NAME=service-b node index.js
```

---

### 5️⃣ Start Service A (payment-service)

```bash
cd ..
OTEL_SERVICE_NAME=payment-service node index.js
```

---

### 6️⃣ Generate Traffic

```bash
curl http://localhost:4000/
curl http://localhost:4000/slow
```

---

## 🔍 Observability Output

* Traces visible in Jaeger UI
* Custom span: `payment-process`
* HTTP call automatically traced
* Latency breakdown across operations

---

## 📊 Example Trace Flow

```
payment-service
   ├── GET /slow
   ├── payment-process (custom span)
   └── HTTP → service-b

service-b
   └── GET /process
```

---

## 🎯 Key Features

* ✅ Auto-instrumentation (HTTP, Express)
* ✅ Custom spans for business logic
* ✅ Cross-service request tracing
* ✅ Performance bottleneck identification
* ✅ Jaeger UI visualization

---

## 🧠 Key Learnings

* How distributed tracing works internally
* Context propagation across services
* Difference between logs, metrics, and traces
* Real-world debugging of microservices

---

## 🚀 Future Enhancements

* Deploy on Kubernetes
* Replace Jaeger with Grafana Tempo
* Add logs correlation (Loki)
* Add metrics (Prometheus + Grafana)

---

## 💼 Resume Line

> Implemented distributed tracing in Node.js microservices using OpenTelemetry and Jaeger, including custom spans and cross-service context propagation for end-to-end request visibility.

---

## 📸 Screenshots

(Add your Jaeger UI screenshots here)

---

## 🙌 Conclusion

This project provides a hands-on understanding of **observability in microservices**, enabling real-time debugging and performance analysis using distributed tracing.
