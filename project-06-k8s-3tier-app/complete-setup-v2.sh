#!/bin/bash

set -e

# =========================
# CONFIG
# =========================
DOCKER_USER="ashishmondal420"
LOG_FILE="setup.log"

exec > >(tee -a $LOG_FILE) 2>&1

echo "======================================"
echo "🚀 Project 06 (Vite Version) Started"
echo "📅 $(date)"
echo "======================================"

# =========================
# Prerequisites Check
# =========================
echo "🔍 Checking prerequisites..."

for cmd in docker kubectl npm; do
  command -v $cmd >/dev/null || { echo "❌ $cmd not installed"; exit 1; }
done

echo "✅ All tools available"

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

app.listen(5000, () => {
  console.log("Server running on port 5000");
});
EOF

cd ..

echo "✅ Backend ready"

# =========================
# Frontend Setup (Vite)
# =========================
echo "🎨 Setting up frontend with Vite..."
cd frontend
rm -rf src public index.html package.json vite.config.js
npm create vite@latest temp-app -- --template react --yes --no-install
cd temp-app
npm install
npm install --yes
shopt -s dotglob
mv * ../
cd ..
rm -rf temp-app
echo "✅ Frontend setup complete (non-interactive)"
cd ..

  useEffect(() => {
    fetch(import.meta.env.VITE_API_URL + "/api")
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
# Fix Dockerfile for Vite
# =========================
echo "🐳 Updating frontend Dockerfile..."

cat <<EOF > frontend/Dockerfile
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install --yes && npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EOF

# =========================
# Build & Push Images
# =========================
echo "🐳 Building images..."

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

# Fix ConfigMap for Vite
sed -i "s|REACT_APP_API_URL|VITE_API_URL|g" k8s/frontend/configmap.yaml

# Add DB_NAME if missing
grep -q DB_NAME k8s/backend/deployment.yaml || \
sed -i '/DB_PASSWORD/a \        - name: DB_NAME\n          value: appdb' k8s/backend/deployment.yaml

echo "✅ YAML updated"

# =========================
# Deploy to Kubernetes
# =========================
echo "☸️ Deploying..."

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/secret.yaml

kubectl apply -f k8s/mysql/
kubectl apply -f k8s/backend/
kubectl apply -f k8s/frontend/
kubectl apply -f k8s/ingress.yaml

echo "✅ Deployment applied"

# =========================
# Wait & Verify
# =========================
echo "⏳ Waiting for pods..."

sleep 10
kubectl get pods -n app

echo "======================================"
echo "🎉 SUCCESS: Project deployed!"
echo "📄 Logs → $LOG_FILE"
echo "======================================"
