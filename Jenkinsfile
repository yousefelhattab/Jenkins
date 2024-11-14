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
        stage('Prompt for Instance Name') {
            steps {
                script {
                    // Prompt user for the instance name
                    instance_name = input message: 'Enter the instance name', parameters: [string(defaultValue: '', description: 'Name of the instance', name: 'instance_name')]
                    echo "Instance name entered: ${instance_name}"
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-credentials') {
                        // Run terraform plan
                        def planStatus = sh(script: 'terraform plan -out=tfplan', returnStatus: true)
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
                        // Apply Terraform changes
                        def applyStatus = sh(script: 'terraform apply -input=false tfplan', returnStatus: true)
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
