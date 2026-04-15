pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ashishmondal420/nodejs-app:latest"
        APP_DIR = "project-1-github-actions/nodejs-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'project-1-github-actions', 
                    url: 'https://github.com/Ashish420-tech/Devops-100-Project.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir("${APP_DIR}") {
                    sh 'npm install'
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir("${APP_DIR}") {
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${APP_DIR}") {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                docker stop nodejs-app || true
                docker rm nodejs-app || true
                docker run -d -p 80:3000 --name nodejs-app ${DOCKER_IMAGE}
                """
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully 🚀'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
