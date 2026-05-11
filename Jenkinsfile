pipeline {
    agent any

    tools {
        nodejs "NodeJS"
    }

    environment {
        VITE_SUPABASE_URL = credentials('VITE_SUPABASE_URL')
        VITE_SUPABASE_ANON_KEY = credentials('VITE_SUPABASE_ANON_KEY')
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

        stage('Create Env File') {
            steps {
                sh '''
                echo "VITE_SUPABASE_URL=$VITE_SUPABASE_URL" > .env
                echo "VITE_SUPABASE_ANON_KEY=$VITE_SUPABASE_ANON_KEY" >> .env
                '''
            }
        }

        stage('Build Application') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                export PATH=$PATH:/opt/homebrew/bin:/usr/local/bin

                docker build -t clothing-store .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                export PATH=$PATH:/opt/homebrew/bin:/usr/local/bin

                docker stop clothing-store-container || true
                docker rm clothing-store-container || true

                docker run -d -p 3000:8080 \
                --name clothing-store-container \
                clothing-store
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}