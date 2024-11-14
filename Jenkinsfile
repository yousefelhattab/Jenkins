pipeline {
    agent any
    parameters {
        string(name: 'INSTANCE_NAME', defaultValue: 'JenkinsInstance', description: 'Name of the EC2 instance')
    }
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
    
