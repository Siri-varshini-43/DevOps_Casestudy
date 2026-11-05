
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'sirivarshini43'
        DOCKERHUB_PASS = 'Siri@2006'
        IMAGE_NAME = 'newspulse'
        KUBECONFIG = 'C:\\Users\\siriv\\.kube\\config'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Code Validation') {
            steps {
                echo 'Validating Python Code...'
                bat 'python -m py_compile app.py'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker Image...'

                bat '''
                docker build -t %DOCKERHUB_USER%/%IMAGE_NAME%:latest .
                docker tag %DOCKERHUB_USER%/%IMAGE_NAME%:latest %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%
                '''
            }
        }

        stage('Docker Login') {
            steps {
                echo 'Logging into Docker Hub...'

                bat '''
                docker login -u %DOCKERHUB_USER% -p "%DOCKERHUB_PASS%"
                '''
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'

                bat '''
                docker push %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                docker push %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%
                docker logout
                '''
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                echo 'Deploying NewsPulse to Kubernetes...'

                bat '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

                kubectl set image deployment/newspulse-deployment newspulse=%DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%

                kubectl rollout status deployment/newspulse-deployment
                '''
            }
        }
    }

    post {
        success {
            echo 'NewsPulse CI/CD Pipeline Executed Successfully!'
        }

        failure {
            echo 'NewsPulse Pipeline Failed!'
        }
    }
}
