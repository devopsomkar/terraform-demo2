pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        DYNATRACE_TENANT      = 'YOUR_DYNATRACE_TENANT'
        DYNATRACE_TOKEN       = credentials('dynatrace-token')
        TF_VAR_aws_region     = 'us-east-1'
        TF_VAR_dynatrace_tenant = env.DYNATRACE_TENANT
        TF_VAR_dynatrace_token  = env.DYNATRACE_TOKEN
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file=terraform.tfvars -out=tfplan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            sh 'terraform destroy -auto-approve || true'
        }
    }
}

