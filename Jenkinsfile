pipeline {
    agent { 
        node {
            label 'docker-agent-python'
        }
    }

    environment {
        SCAN_REPORT_HTML = 'bandit_report.html'
        SCAN_REPORT_JSON = 'bandit_output.json'
        TRIVY_REPORT     = 'trivy_report.json'
        TF_PLAN_FILE     = 'tfplan'
    }

    stages {

        stage('SCM Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init + Validate + Plan') {
            steps {
                echo "Initializing Terraform..."
                sh '''
                    terraform init
                    terraform validate
                    terraform plan -out=${TF_PLAN_FILE}
                '''
            }
        }

        stage('IaC Security Scan - tfsec') {
            steps {
                echo "Running tfsec for Terraform code..."
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
                    pip3 install bandit
                    bandit -r myapp -f json -o ${SCAN_REPORT_JSON}
                    bandit -r myapp -f html -o ${SCAN_REPORT_HTML}
                '''
            }
        }

        stage('Trivy Scan - File System') {
            steps {
                echo "Running Trivy file system scan..."
                sh '''
                    sudo apt-get update -y
                    sudo apt-get install -y wget
                    wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.50.2_Linux-64bit.deb
                    sudo dpkg -i trivy_0.50.2_Linux-64bit.deb
                    trivy fs . --format json --output ${TRIVY_REPORT} || true
                '''
            }
        }

        stage('Terraform Apply (Deploy EC2)') {
            steps {
                echo "Applying Terraform to deploy infrastructure..."
                sh '''
                    terraform apply -auto-approve ${TF_PLAN_FILE}
                '''
            }
        }
    }

    post {
        always {
            echo "Archiving security scan results..."
            archiveArtifacts artifacts: '**/*.html, **/*.json', allowEmptyArchive: true
        }
    }
}
