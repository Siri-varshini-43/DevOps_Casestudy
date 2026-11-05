
pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'sirivarshini43'
        IMAGE_NAME = 'newspulse'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Code Validation') {
            steps {
                bat 'python -m py_compile app.py'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %DOCKERHUB_USER%/%IMAGE_NAME%:latest .'
                bat 'docker tag %DOCKERHUB_USER%/%IMAGE_NAME%:latest %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    docker push %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                    docker push %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%
                    docker logout
                    '''
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                withCredentials([
                    file(
                        credentialsId: 'kubeconfig',
                        variable: 'KUBECONFIG'
                    )
                ]) {
                    bat '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                    kubectl set image deployment/newspulse-deployment newspulse=%DOCKERHUB_USER%/%IMAGE_NAME%:latest
                    kubectl rollout status deployment/newspulse-deployment
                    '''
                }
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
