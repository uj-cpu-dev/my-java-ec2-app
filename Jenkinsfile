pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        AWS_REGION = 'us-east-1' // e.g., us-east-1
        REPO_NAME = 'my-java-app' // Your ECR repository name
        ECR_REGISTRY = "992382383822.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Set Image Tag') {
            steps {
                echo "Setting the image tag..."
                script {
                    def gitCommitHash = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    def shortCommitHash = gitCommitHash.substring(0, 7) 
                    env.IMAGE_TAG = "feature-branch-${shortCommitHash}"
                    echo "Image tag set to: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Login to ECR') {
            steps {
                echo "Logging in to Amazon ECR..."
                script {
                    def ecrLogin = sh(script: "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}", returnStatus: true)
                    if (ecrLogin != 0) {
                        error "ECR login failed!"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    sh "docker build -t ${REPO_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                echo "Tagging Docker image..."
                script {
                    sh "docker tag ${REPO_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to ECR') {
            steps {
                echo "Pushing Docker image to Amazon ECR..."
                script {
                    sh "docker push ${ECR_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "Build and push to ECR successful!"
        }
        failure {
            echo "Build or push failed."
        }
    }
}
