pipeline {
    agent { label 'python-docker' }

    stages {
        stage('Install Python Requirements + Build App') {
          }
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
                sh '''
                   bandit --version
                '''
            }
        }

       stage('Terraform Init + Plan (AWS)') {
         steps {
         dir('terraform/aws') {
              sh '''
                 terraform init
                 terraform plan -out=${TF_PLAN_AWS}
               '''
                }
            }
        }

        /*stage('Test') {
            steps {
                echo "Testing.."
                sh '''
               python3-
                '''
            }
        }*/

        stage('Security Scan - tfsec') {
        steps {
         sh '''
           tfsec terraform/aws || true
         '''
         }
       }


        stage('Security Scan - Trivy') {
         steps {
          sh '''
           trivy fs . --format json --output ${TRIVY_REPORT} || true
         '''
          }
        }

       stage('Terraform Apply (AWS)') {
         steps {
          dir('terraform/aws') {
           sh 'terraform apply -auto-approve ${TF_PLAN_AWS}'
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