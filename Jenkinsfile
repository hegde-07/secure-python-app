pipeline {
    agent any

    environment {
    TF_PLAN_AWS   = 'aws.tfplan'
    TF_PLAN_OCI   = 'oci.tfplan'
    BANDIT_JSON   = 'bandit_output.json'
    BANDIT_HTML   = 'bandit_report.html'
    TRIVY_REPORT  = 'trivy_report.json'
    GREETING_NAME = 'Brad'
  }

    stages {
        stage('Build') {
            steps {
                sh '''
                 cd myapp
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

        stage('Terraform Init + Plan (Oracle Cloud)') {
         steps {
            dir('terraform/oci') {
            sh '''
                terraform init
                terraform plan -out=${TF_PLAN_OCI}
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
           tfsec terraform/oci || true
         '''
         }
       }

      stage('Security Scan - Bandit') {
         steps {
         sh '''
           
           bandit -r myapp -f json -o bandit_output.json || true
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

       stage('Terraform Apply (AWS + Oracle)') {
        steps {
          dir('terraform/aws') {
           sh 'terraform apply -auto-approve ${TF_PLAN_AWS}'
         }
         dir('terraform/oci') {
              sh 'terraform apply -auto-approve ${TF_PLAN_OCI}'
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