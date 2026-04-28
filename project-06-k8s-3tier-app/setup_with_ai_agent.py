import os
import subprocess
import time
import shutil
import requests

# =========================
# CONFIG
# =========================
DOCKER_USER = "ashishmondal420"
NAMESPACE = "app"
BASE_DIR = os.getcwd()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

# =========================
# Helpers
# =========================
def run(cmd):
    print(f"\n▶️ {cmd}")
    subprocess.run(cmd, shell=True, check=True)

def run_output(cmd):
    return subprocess.check_output(cmd, shell=True).decode()

# =========================
# Backend Setup
# =========================
def setup_backend():
    print("📦 Setting up backend...")

    backend_path = os.path.join(BASE_DIR, "backend")
    os.makedirs(backend_path, exist_ok=True)

    with open(os.path.join(backend_path, "package.json"), "w") as f:
        f.write("""{
  "name": "backend",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2"
  }
}""")

    with open(os.path.join(backend_path, "server.js"), "w") as f:
        f.write("""
const express = require("express");
const app = express();

app.get("/api", (req, res) => {
  res.send("Backend working 🚀");
});

app.listen(5000, () => console.log("Running"));
""")

    with open(os.path.join(backend_path, "Dockerfile"), "w") as f:
        f.write("""
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
""")

    print("✅ Backend ready")

# =========================
# Frontend Setup (SAFE)
# =========================
def setup_frontend():
    print("🎨 Setting up frontend...")

    frontend_path = os.path.join(BASE_DIR, "frontend")
    temp_path = os.path.join(frontend_path, "temp-app")

    os.makedirs(frontend_path, exist_ok=True)

    # Clean only temp + src
    if os.path.exists(temp_path):
        shutil.rmtree(temp_path)

    src_path = os.path.join(frontend_path, "src")
    if os.path.exists(src_path):
        shutil.rmtree(src_path)

    os.chdir(frontend_path)

    # Clone template
    run("git clone https://github.com/vitejs/vite.git temp-app")

    template_path = os.path.join(temp_path, "packages/create-vite/template-react")

    # Copy files safely
    run(f"cp -r {template_path}/* {frontend_path}/")

    # Remove temp
    shutil.rmtree(temp_path)

    # Install dependencies
    run("npm install")

    # Dockerfile
    with open(os.path.join(frontend_path, "Dockerfile"), "w") as f:
        f.write("""
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
""")

    os.chdir(BASE_DIR)
    print("✅ Frontend ready")

# =========================
# Docker Build & Push
# =========================
def build_and_push():
    print("🐳 Building images...")

    run(f"docker build -t {DOCKER_USER}/backend:latest ./backend")
    run(f"docker build -t {DOCKER_USER}/frontend:latest ./frontend")

    print("📤 Pushing images...")
    run(f"docker push {DOCKER_USER}/backend:latest")
    run(f"docker push {DOCKER_USER}/frontend:latest")

# =========================
# Deploy
# =========================
def deploy():
    print("☸️ Deploying...")

    if not os.path.exists("k8s"):
        print("⚠️ k8s folder missing")
        return

    run("kubectl apply -f k8s/")

# =========================
# AI (Optional)
# =========================
def ask_ai(log):
    if not OPENAI_API_KEY:
        return "No API key"

    try:
        response = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers={"Authorization": f"Bearer {OPENAI_API_KEY}"},
            json={
                "model": "gpt-4o-mini",
                "messages": [{"role": "user", "content": log}]
            }
        )
        return response.json()["choices"][0]["message"]["content"]
    except Exception as e:
        return str(e)

# =========================
# Agent Loop
# =========================
def agent():
    print("🤖 Agent started")

    while True:
        try:
            pods = run_output(f"kubectl get pods -n {NAMESPACE} --no-headers")

            for line in pods.splitlines():
                name = line.split()[0]

                if "CrashLoopBackOff" in line:
                    logs = run_output(f"kubectl logs {name} -n {NAMESPACE} --tail=20")
                    print("⚠️ Crash:", name)
                    print(ask_ai(logs))
                    run(f"kubectl delete pod {name} -n {NAMESPACE}")

            time.sleep(20)

        except Exception as e:
            print("Agent error:", e)
            time.sleep(10)

# =========================
# MAIN
# =========================
if __name__ == "__main__":
    setup_backend()
    setup_frontend()
    build_and_push()
    deploy()
    agent()
