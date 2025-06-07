pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo "Installing dependencies and security tools..."
                sh '''
                    python3 -m pip install --upgrade pip
                    pip install -r myapp/requirements.txt
                '''
            }pipeline {
    agent { 
        node {
            label 'docker-agent-python'
            }
      }
    stages {
        stage('Build') {
            steps {
                echo "Building.."
                sh '''
                cd myapp
                python3 hello.py
                '''
            }
        }
        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                echo "doing test stuff.."
                '''
            }
        }
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo "doing delivery stuff.."
                '''
            }
        }
    }
}
        }

        stage('SAST - Bandit') {
            steps {
                echo "Running static code analysis with Bandit..."
                sh 'bandit -r myapp || true'
            }
        }

        stage('Dependency Scan - Trivy') {
            steps {
                echo "Running Trivy filesystem scan..."
                sh '''
                    if ! command -v trivy > /dev/null; then
                      echo "Installing Trivy..."
                      wget -qO- https://aquasecurity.github.io/trivy-repo/deb/setup.sh | sudo bash
                      sudo apt install trivy -y
                    fi
                    trivy fs --exit-code 0 --severity HIGH,CRITICAL .
                '''
            }
        }

        stage('Deliver') {
            steps {
                echo 'Pipeline completed. Ready to deploy!'
            }
        }
    }
}
