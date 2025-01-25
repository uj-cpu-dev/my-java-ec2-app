pipeline {
    agent any

    stages {
        stage('Echo Hello Jenkins') {
            steps {
                echo 'Hello Jenkins'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}