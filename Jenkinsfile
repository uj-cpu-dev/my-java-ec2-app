pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        REPO_NAME = 'my-java-app'
        ECR_REGISTRY = "992382383822.dkr.ecr.${AWS_REGION}.amazonaws.com"
        CLUSTER_NAME = 'my-eks-cluster'
        NAMESPACE = 'default'
        IMAGE_TAG = ''
    }

    stages {
        stage('Set Image Tag') {
            steps {
                script {
                    sh './scripts/set-image-tag.sh'
                    env.IMAGE_TAG = readFile('image-tag.txt').trim()
                    echo "Image tag set to: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Checkout Code') {
            steps {
                script {
                    sh './jenkins/scripts/checkout.sh'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh './jenkins/scripts/login-ecr.sh'
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    sh './jenkins/scripts/build-and-push.sh'
                }
            }
        }

        stage('Configure Kubernetes and Helm') {
            steps {
                script {
                    sh './jenkins/scripts/configure-k8s-helm.sh'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh './jenkins/scripts/deploy-helm.sh'
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    sh './jenkins/scripts/health-check.sh'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
