pipeline {
    agent any

    environment {
        IMAGE_NAME = "seifkhaled123/devops-dashboard:latest"
    }

    stages {

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

        stage('Deploy') {
            steps {
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml'
            }
        }
    }

    post {

        success {
            echo "✅ SUCCESS: Pipeline completed (Build + Push + Deploy)"
        }

        failure {
            echo "❌ FAILED: Something went wrong in CI/CD pipeline"
        }

        always {
            echo "🔄 Pipeline finished"
        }
    }
}
