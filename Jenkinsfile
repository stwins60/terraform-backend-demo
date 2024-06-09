pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = credentials('65cf11bb-1133-4170-8acf-0812e41d9377')
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'prod'], description: 'Select the environment to deploy')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select the action to perform')
    }

    stages {
        stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/stwins60/terraform-backend-demo.git'
            }
        }
        stage('Terraform init') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '65cf11bb-1133-4170-8acf-0812e41d9377', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        if (params.ENVIRONMENT == 'dev') {
                            sh 'sed -i "s|TERRAFORM_STATE_FILE|dev-terraform.tfstate|g" dev/backend-config.tfvars'
                            sh 'terraform init -backend-config="dev/backend-config.tfvars"'
                        } else if (params.ENVIRONMENT == 'prod') {
                            sh 'sed -i "s|TERRAFORM_STATE_FILE|prod-terraform.tfstate|g" prod/backend-config.tfvars'
                            sh 'terraform init -backend-config="prod/backend-config.tfvars"'
                        }
                    }
                }
            }
        }
        stage('Terraform plan') {
            when {
                expression { params.ACTION == 'plan' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '65cf11bb-1133-4170-8acf-0812e41d9377', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        stage('Terraform apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '65cf11bb-1133-4170-8acf-0812e41d9377', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
        stage('Terraform destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: '65cf11bb-1133-4170-8acf-0812e41d9377', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
