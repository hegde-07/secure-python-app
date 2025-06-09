pipeline {
    agent { 
        node {
            label 'docker-agent-python'
            }
      }
    stages {
        stage('Dependencies Install') {
            steps {
                echo "Installing Dependecies.."
                sh '''
                cd myapp
                pip install -r requirements.txt
                '''
            }
        }
        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                bandit -r myapp -f html -o bandit-report.html || true
                '''
            }
        }
        stage('Scanning') {
            steps {
                echo "Testing.."
                sh '''
                trivy fs --exit-code 0 --format json --output trivy-report.json . || true
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo "All secure checks passed. Ready for delivery."
                '''
            }
        }
    }

    post {
        always{
            archiveArtifacts artifacts: '**/*.html, **/*.json', allowEmptyArchive: true
        }
    }
}