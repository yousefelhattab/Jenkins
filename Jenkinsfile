pipeline {
    agent any

    parameters {
        string(name: 'INSTANCE_NAME', defaultValue: 'JenkinsInstance', description: 'Name of the EC2 instance')
    }

    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/yousefelhattab/Jenkins.git'
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
                    // Generate a terraform variable file with the instance name from the parameter
                    writeFile file: 'terraform.tfvars', text: "instance_name = \"${params.INSTANCE_NAME}\"\n"
                    echo "Terraform variable file generated with instance name: ${params.INSTANCE_NAME}"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-credentials') {
                        // Run terraform plan with the instance_name variable
                        def planStatus = sh(script: 'terraform plan -var-file=terraform.tfvars -out=tfplan', returnStatus: true)
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
                        def applyStatus = sh(script: 'terraform apply -var-file=terraform.tfvars -input=false tfplan', returnStatus: true)
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
