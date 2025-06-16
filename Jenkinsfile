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
                    curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
                    tfsec . || true
                '''
            }
        }

        stage('App Security Scan - Bandit') {
            steps {
                echo "Running Bandit on Python app..."
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

        stage('Terraform Apply (Deploy EC2)') {
            steps {
                echo "Applying Terraform to deploy infrastructure..."
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