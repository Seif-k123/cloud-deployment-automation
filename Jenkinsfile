pipeline {
    agent any

    environment {
        IMAGE_NAME = "seifkhaled123/devops-dashboard:latest"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-dashboard ./docker'
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

        stage('Deploy') {
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
            }
        }
    }

    post {

        success {
            echo "✅ Pipeline SUCCESS: Build, Push, and Deploy completed successfully!"
        }

        failure {
            echo "❌ Pipeline FAILED: Something went wrong during CI/CD process!"
        }

        always {
            echo "🔄 Pipeline finished (success or failure). Cleaning up if needed..."
        }
    }
}
