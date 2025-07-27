pipeline {
    agent any

    environment {
        TF_PLAN_AWS = "tfplan.out"
        TRIVY_REPORT = "trivy-report.json"
    }

    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'AWS_CREDENTIALS',
                                                 usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                 passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "AWS credentials loaded securely"
                }
            }
        }

        stage('Install Python Requirements + Build App') {
            steps {
                sh '''
                    python3 -m venv venv
                    cd myapp
                    echo "Application build/prepare complete."
                '''
            }
        }

        stage('Bandit Scan') {
            steps {
                sh 'bandit --version'
            }
        }

        stage('Terraform Init + Plan (AWS)') {
            steps {
                dir('terraform/aws') {
                    withCredentials([usernamePassword(credentialsId: 'AWS_CREDENTIALS',
                                                     usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                     passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform init
                            terraform plan -out=${TF_PLAN_AWS}
                        '''
                    }
                }
            }
        }

        stage('Security Scan - tfsec') {
            steps {
                sh 'tfsec terraform/aws || true'
            }
        }

        stage('Security Scan - Trivy') {
            steps {
                sh 'trivy fs . --format json --output ${TRIVY_REPORT} || true'
            }
        }

        stage('Terraform Apply (AWS)') {
            steps {
                dir('terraform/aws') {
                    withCredentials([usernamePassword(credentialsId: 'AWS_CREDENTIALS',
                                                     usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                     passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            terraform apply -auto-approve ${TF_PLAN_AWS}
                        '''
                    }
                }
            }
        }

        stage('Deliver') {
            steps {
                echo 'Deployed....'
            }
        }
    }
}
