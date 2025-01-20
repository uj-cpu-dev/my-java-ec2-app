pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'        // e.g., us-east-1
        REPO_NAME = 'my-java-app'       // Your ECR repository name
        IMAGE_TAG = "${env.BUILD_NUMBER}" // Use build number as tag
        ECR_REGISTRY = "992382383822.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ROLE_ARN = 'arn:aws:iam::992382383822:role/jenkinsServerRole' // Replace with your Role ARN
        ROLE_SESSION_NAME = 'jenkins-session'
    }

    stages {
        stage('Assume IAM Role') {
            steps {
                echo "Assuming IAM role..."
                script {
                    def assumeRoleCommand = """
                    aws sts assume-role \
                    --role-arn ${ROLE_ARN} \
                    --role-session-name ${ROLE_SESSION_NAME} \
                    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
                    --output text
                    """
                    def credentials = sh(script: assumeRoleCommand, returnStdout: true).trim().split("\\s+")
                    env.AWS_ACCESS_KEY_ID = credentials[0]
                    env.AWS_SECRET_ACCESS_KEY = credentials[1]
                    env.AWS_SESSION_TOKEN = credentials[2]
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
                echo "Logging in to Amazon ECR using assumed IAM role..."
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