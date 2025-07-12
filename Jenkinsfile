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
                sudo python3 -m venv venv
                 . venv/bin/activate
                 pip install -r requirements.txt
               '''
            }
        }

       /*age('Terraform Init + Plan (AWS)') {
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
        }  */

        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                cd myapp
                python3 hello.py
                python3 hello.py --name=Brad
                '''
            }
        }

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
           bandit -r myapp -f json -o ${BANDIT_JSON}
           bandit -r myapp -f html -o ${BANDIT_HTML}
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

       /*tage('Terraform Apply (AWS + Oracle)') {
        steps {
          dir('terraform/aws') {
           sh 'terraform apply -auto-approve ${TF_PLAN_AWS}'
         }
         dir('terraform/oci') {
              sh 'terraform apply -auto-approve ${TF_PLAN_OCI}'
            }
        }
       }*/
        stage('Deliver') {
            steps {
                echo 'Deliver....'
                sh '''
                echo "Deployed
                '''
            }
        }
    }
}