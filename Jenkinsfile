pipeline {
  agent any
  options { ansiColor('xterm') }

  environment {
    AWS_REGION        = 'eu-central-1'
    TF_IN_AUTOMATION  = 'true'
    TF_INPUT          = 'false'

    
    TF_BACKEND_BUCKET = 'tf-state-...'
    TF_BACKEND_KEY    = 'lakehouse/terraform.tfstate'
    TF_LOCK_TABLE     = 'tf-lock-...'

    // Ha Access Key-t használsz:
    // AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    // AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    // AWS_SESSION_TOKEN     = credentials('AWS_SESSION_TOKEN') // ha van
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform Init/Validate/Plan (Docker)') {
      steps {
        script {
          def tf = docker.image('hashicorp/terraform:1.9.5')
          tf.pull()
          tf.inside('--entrypoint=') {
            dir('terraform') {
              sh """
                terraform -version
                terraform init -reconfigure \
                  -backend-config="bucket=$TF_BACKEND_BUCKET" \
                  -backend-config="key=$TF_BACKEND_KEY" \
                  -backend-config="region=$AWS_REGION" \
                  -backend-config="dynamodb_table=$TF_LOCK_TABLE"

                terraform fmt -recursive
                terraform validate
                terraform plan -out=tfplan
              """
            }
          }
        }
      }
    }

    stage('Apply (manual, only on main)') {
      when { branch 'main' }
      steps {
        input message: 'Approve Terraform apply?'
        script {
          def tf = docker.image('hashicorp/terraform:1.9.5')
          tf.inside('--entrypoint=') {
            dir('terraform') {
              sh 'terraform apply -auto-approve tfplan'
            }
          }
        }
      }
    }
  }

  post {
    always { cleanWs() }
  }
}