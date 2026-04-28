#!/bin/bash

set -e

# =========================
# CONFIG
# =========================
DOCKER_USER="ashishmondal420"
LOG_FILE="setup.log"

# =========================
# Logging Setup
# =========================
exec > >(tee -a $LOG_FILE) 2>&1

echo "======================================"
echo "🚀 Project 06 Setup Started"
echo "📅 $(date)"
echo "======================================"

# =========================
# Check prerequisites
# =========================
echo "🔍 Checking prerequisites..."

command -v docker >/dev/null || { echo "❌ Docker not installed"; exit 1; }
command -v kubectl >/dev/null || { echo "❌ kubectl not installed"; exit 1; }

echo "✅ Prerequisites OK"

# =========================
# Backend Setup
# =========================
echo "📦 Setting up backend..."

cd backend

cat <<EOF > package.json
{
  "name": "backend",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "mysql2": "^3.9.0"
  }
}
EOF

cat <<EOF > server.js
const express = require("express");
const mysql = require("mysql2");

const app = express();

const db = mysql.createConnection({
  host: process.env.DB_HOST || "mysql",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "rootpass",
  database: process.env.DB_NAME || "appdb"
});

app.get("/api", (req, res) => {
  res.send("Backend is working 🚀");
});

app.get("/db", (req, res) => {
  db.query("SELECT NOW()", (err, result) => {
    if (err) return res.status(500).send(err);
    res.json(result);
  });
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});
EOF

cd ..

echo "✅ Backend ready"

# =========================
# Frontend Setup
# =========================
echo "🎨 Setting up frontend..."

cd frontend

if [ ! -d "src" ]; then
  echo "📦 Creating React app..."
  npx create-react-app . --use-npm
fi

cat <<EOF > src/App.js
import { useEffect, useState } from "react";

function App() {
  const [msg, setMsg] = useState("");

  useEffect(() => {
    fetch(process.env.REACT_APP_API_URL + "/api")
      .then(res => res.text())
      .then(data => setMsg(data));
  }, []);

  return (
    <div>
      <h1>3-Tier App 🚀</h1>
      <p>{msg}</p>
    </div>
  );
}

export default App;
EOF

cd ..

echo "✅ Frontend ready"

# =========================
# Docker Build & Push
# =========================
echo "🐳 Building Docker images..."

docker build -t $DOCKER_USER/backend:latest ./backend
docker build -t $DOCKER_USER/frontend:latest ./frontend

echo "📤 Pushing images..."

docker push $DOCKER_USER/backend:latest
docker push $DOCKER_USER/frontend:latest

echo "✅ Images pushed"

# =========================
# Update Kubernetes YAML
# =========================
echo "⚙️ Updating Kubernetes manifests..."

sed -i "s|your-dockerhub/backend:latest|$DOCKER_USER/backend:latest|g" k8s/backend/deployment.yaml || true
sed -i "s|your-dockerhub/frontend:latest|$DOCKER_USER/frontend:latest|g" k8s/frontend/deployment.yaml || true

grep -q DB_NAME k8s/backend/deployment.yaml || sed -i '/DB_PASSWORD/a \        - name: DB_NAME\n          value: appdb' k8s/backend/deployment.yaml

echo "✅ YAML updated"

# =========================
# Deploy to Kubernetes
# =========================
echo "☸️ Deploying to Kubernetes..."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secret.yaml

kubectl apply -f k8s/mysql/
kubectl apply -f k8s/backend/
kubectl apply -f k8s/frontend/

kubectl apply -f k8s/ingress.yaml

echo "✅ Deployment triggered"

# =========================
# Wait for Pods
# =========================
echo "⏳ Waiting for pods..."

sleep 10
kubectl get pods -n app

# =========================
# Final Status
# =========================
echo "======================================"
echo "🎉 Setup Completed Successfully!"
echo "📄 Logs saved in: $LOG_FILE"
echo "======================================"
