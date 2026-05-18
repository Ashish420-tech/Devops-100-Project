# Project 01 — Dockerized Flask Application

## Overview
This project demonstrates containerizing a Python Flask web application using Docker and deploying it locally.

It is part of my DevOps 100 Projects portfolio.

## Tech Stack
- Git
- GitHub
- Python 3.11
- Flask
- Docker
- WSL Ubuntu

## Project Structure
```bash
project-01-docker-flask-app/
├── app/
│   ├── app.py
│   └── requirements.txt
├── screenshots/
├── architecture/
├── Dockerfile
├── .gitignore
└── README.md
```

## Application Endpoints

Home:
```bash
http://localhost:5000
```

Health Check:
```bash
http://localhost:5000/health
```

## Build Docker Image
```bash
docker build -t project01-flask .
```

## Run Container
```bash
docker run -d -p 5000:5000 --name project01 project01-flask
```

## Verify
```bash
docker ps
curl http://localhost:5000
curl http://localhost:5000/health
```

## Container Lifecycle
Stop:
```bash
docker stop project01
```

Start:
```bash
docker start project01
```

Logs:
```bash
docker logs project01
```

Delete container:
```bash
docker rm -f project01
```

Delete image:
```bash
docker rmi project01-flask
```

## Architecture Flow
Developer → GitHub → Docker Build → Container → Flask App → Browser

## Screenshots
Add:
- app-running.png
- docker-ps.png
- health-check.png
- github-repo.png

## Learning Outcome
This project helped me understand:
- Docker image creation
- Container deployment
- Port mapping
- Flask application deployment
- Container lifecycle management
- GitHub project organization
