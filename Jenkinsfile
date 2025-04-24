pipeline {
    agent any
    environment {
        ACR_NAME = "acrjenkinsdocker"
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        RESOURCE_GROUP = 'rg-jenkins-docker-aks'
        AKS_CLUSTER = 'aks-cluster-docker-jenkins'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/deepakmanghani1511/aks-integerate1.git'
            }
        }

        
         stage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/webapplication:latest -f WebApplication1/WebApplication1/Dockerfile WebApplication1"
            }
        }

         stage('Terraform Init') {
                steps {
                     withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    dir('terraform') {
                        bat 'terraform init'
                    }
                }
                }
          }
          stage('Terraform Plan & Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                dir('terraform') {
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
            }
        }

        
         stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/webapplication:latest"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f terraform/deployment.yaml"
            }
        }

        stage('AKS Startup') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                bat "az aks get-credentials --resource-group rg-jenkins-docker-aks --name aks-cluster-docker-jenkins"
                bat "kubectl get service dotnet-api-service"}
            }
        }

    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
