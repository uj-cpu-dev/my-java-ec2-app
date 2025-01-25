pipeline {
    agent any

    stages {
        stage('Echo Hello World') {
            steps {
                echo 'Hello World'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}