pipeline {
    agent any

    environment {
        IMAGE_NAME = "seifkhaled123/devops-dashboard:latest"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // IMPORTANT: build from project root
                sh 'docker build -t devops-dashboard .'
            }
        }

        stage('Tag Image') {
            steps {
                sh 'docker tag devops-dashboard $IMAGE_NAME'
            }
        }

        stage('Docker Login') {
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

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
            }
        }
    }

    post {

        success {
            echo "✅ SUCCESS: CI/CD Pipeline completed successfully!"
        }

        failure {
            echo "❌ FAILED: CI/CD Pipeline broke. Check logs!"
        }

        always {
            echo "🔄 Pipeline finished (cleanup or logging step)"
        }
    }
}
