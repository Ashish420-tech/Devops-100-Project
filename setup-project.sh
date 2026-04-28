#!/bin/bash

set -e

PROJECT_NAME="project-06-k8s-3tier-app"

echo "🚀 Creating project structure..."

mkdir -p $PROJECT_NAME
cd $PROJECT_NAME



# ------------------------
# Frontend
# ------------------------
mkdir -p frontend
cd frontend

cat <<EOF > Dockerfile
# Build stage
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Serve with nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EOF

touch README.md
cd ..

# ------------------------
# Backend
# ------------------------
mkdir -p backend
cd backend

cat <<EOF > Dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["node", "server.js"]
EOF

touch README.md
cd ..

# ------------------------
# Kubernetes Structure
# ------------------------
mkdir -p k8s/mysql
mkdir -p k8s/backend
mkdir -p k8s/frontend

# Namespace
cat <<EOF > k8s/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: app
EOF

# Secret
cat <<EOF > k8s/secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
  namespace: app
type: Opaque
stringData:
  MYSQL_ROOT_PASSWORD: rootpass
  MYSQL_DATABASE: appdb
EOF

# ------------------------
# MySQL
# ------------------------
cat <<EOF > k8s/mysql/pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: app
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

cat <<EOF > k8s/mysql/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8
        envFrom:
        - secretRef:
            name: db-secret
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-storage
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
EOF

cat <<EOF > k8s/mysql/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: app
spec:
  ports:
    - port: 3306
  selector:
    app: mysql
EOF

# ------------------------
# Backend
# ------------------------
cat <<EOF > k8s/backend/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: your-dockerhub/backend:latest
        env:
        - name: DB_HOST
          value: mysql
        - name: DB_USER
          value: root
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: MYSQL_ROOT_PASSWORD
EOF

cat <<EOF > k8s/backend/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: app
spec:
  ports:
    - port: 5000
  selector:
    app: backend
EOF

# ------------------------
# Frontend
# ------------------------
cat <<EOF > k8s/frontend/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-config
  namespace: app
data:
  REACT_APP_API_URL: http://backend:5000
EOF

cat <<EOF > k8s/frontend/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: your-dockerhub/frontend:latest
        envFrom:
        - configMapRef:
            name: frontend-config
EOF

cat <<EOF > k8s/frontend/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: app
spec:
  ports:
    - port: 80
  selector:
    app: frontend
EOF

# ------------------------
# Ingress
# ------------------------
cat <<EOF > k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: app
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend
            port:
              number: 5000
EOF

# ------------------------
# Root README
# ------------------------
cat <<EOF > README.md
# 🚀 Project 06 - 3 Tier App on Kubernetes

React + Node.js + MySQL deployed on Kubernetes using Ingress.
EOF

echo "✅ Project structure created successfully!"
