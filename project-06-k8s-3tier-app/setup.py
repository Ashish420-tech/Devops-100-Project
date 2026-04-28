import subprocess
import os
import time

DOCKER_USER = "ashishmondal420"
NAMESPACE = "app"


def run(cmd):
    print(f"\n▶️ Running: {cmd}")
    subprocess.run(cmd, shell=True, check=True)


# --------------------------
# Backend Setup
# --------------------------
def setup_backend():
    print("📦 Setting up backend...")
    os.chdir("backend")

    with open("package.json", "w") as f:
        f.write("""{
  "name": "backend",
  "version": "1.0.0",
  "main": "server.js",
  "dependencies": {
    "express": "^4.18.2",
    "mysql2": "^3.9.0"
  }
}""")

    with open("server.js", "w") as f:
        f.write("""
const express = require("express");
const app = express();

app.get("/api", (req, res) => {
  res.send("Backend is working 🚀");
});

app.listen(5000);
""")

    os.chdir("..")


# --------------------------
# Frontend Setup (NON-INTERACTIVE)
# --------------------------
def setup_frontend():
    print("🎨 Setting up frontend (non-interactive)...")

    os.chdir("frontend")
    run("rm -rf *")

    # Clone template instead of vite CLI
    run("git clone https://github.com/vitejs/vite.git temp-app")

    os.chdir("temp-app/packages/create-vite/template-react")
    run("cp -r . ../../../")

    os.chdir("../../..")
    run("rm -rf temp-app")

    run("npm install")
    os.chdir("..")


# --------------------------
# Docker Build & Push
# --------------------------
def build_push():
    print("🐳 Building images...")

    run(f"docker build -t {DOCKER_USER}/backend:latest ./backend")
    run(f"docker build -t {DOCKER_USER}/frontend:latest ./frontend")

    run(f"docker push {DOCKER_USER}/backend:latest")
    run(f"docker push {DOCKER_USER}/frontend:latest")


# --------------------------
# Deploy K8s
# --------------------------
def deploy():
    print("☸️ Deploying...")

    run("kubectl apply -f k8s/")


# --------------------------
# AI Agent (Self-Healing)
# --------------------------
def ai_agent():
    print("🤖 AI Agent started...")

    while True:
        pods = subprocess.check_output(
            f"kubectl get pods -n {NAMESPACE} --no-headers",
            shell=True
        ).decode()

        for line in pods.splitlines():
            name = line.split()[0]

            if "CrashLoopBackOff" in line:
                print(f"⚠️ Restarting {name}")
                run(f"kubectl delete pod {name} -n {NAMESPACE}")

            if "ImagePullBackOff" in line:
                print(f"⚠️ Image issue in {name}")
                run(f"kubectl describe pod {name} -n {NAMESPACE}")

        time.sleep(20)


# --------------------------
# MAIN
# --------------------------
if __name__ == "__main__":
    setup_backend()
    setup_frontend()
    build_push()
    deploy()

    # Optional: run agent
    ai_agent()
