// Prompt for instance name before pipeline starts
def instance_name = input message: 'Enter the instance name', parameters: [string(defaultValue: '', description: 'Name of the instance', name: 'instance_name')]

pipeline {
    agent any
    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/yousefelhattab/Jenkins'
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Use the AWS credentials injected by the plugin
                    withAWS(credentials: 'aws-credentials') {
                        // Initialize Terraform
                        def initStatus = sh(script: 'terraform init -input=false', returnStatus: true)
                        if (initStatus != 0) {
                            error "Terraform Init failed!"
                        }
                    }
                }
            }
        }
        stage('Generate Terraform Variables File') {
            steps {
                script {
                    // Generate a terraform variable file with the instance name
                    writeFile file: 'instance_name.tfvars', text: "instance_name = \"${instance_name}\"\n"
                    echo "Terraform variable file generated with instance name: ${instance_name}"
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-credentials') {
                        // Run terraform plan with the instance_name variable
                        def planStatus = sh(script: 'terraform plan -var-file=instance_name.tfvars -out=tfplan', returnStatus: true)
                        if (planStatus != 0) {
                            error "Terraform Plan failed!"
                        }
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    withAWS(credentials: 'aws-credentials') {
                        // Apply Terraform changes with the instance_name variable
                        def applyStatus = sh(script: 'terraform apply -var-file=instance_name.tfvars -input=false tfplan', returnStatus: true)
                        if (applyStatus != 0) {
                            error "Terraform Apply failed!"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Terraform applied successfully'
        }
        failure {
            echo 'Terraform apply failed'
        }
    }
}
