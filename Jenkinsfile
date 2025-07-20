pipeline {
    agent none

    stages {
        stage('Install Python Requirements + Build App') {

          agent{
            node {
              label 'python-docker'
            }
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
          agent any  // ru
            steps {
                sh '''
                   bandit --version
                '''
            }
        }

       stage('Terraform Init + Plan (AWS)') {
        agent any
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
        agent any
        steps {
         sh '''
           tfsec terraform/aws || true
         '''
         }
       }


        stage('Security Scan - Trivy') {
        agent any
         steps {
          sh '''
           trivy fs . --format json --output ${TRIVY_REPORT} || true
         '''
          }
        }

       stage('Terraform Apply (AWS)') {
        agent any
         steps {
          dir('terraform/aws') {
           sh 'terraform apply -auto-approve ${TF_PLAN_AWS}'
         }
        }
       }
        stage('Deliver') {
        agent any
            steps {
                echo 'Deployed....'
            }
        }
    }
}