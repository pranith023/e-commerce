pipeline {
    agent any

    tools {
        nodejs "NodeJS"
    }

    stages {

        stage('Clone Code') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Application') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t clothing-store .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop clothing-store-container || true
                docker rm clothing-store-container || true
                docker run -d -p 3000:8080 --name clothing-store-container clothing-store
                '''
            }
        }
    }
}