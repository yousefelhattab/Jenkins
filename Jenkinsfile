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
                    withAWS(credentials: 'aws-credentials') {
                        def initStatus = sh(script: 'terraform init -input=false', returnStatus: true)
                        if (initStatus != 0) {
                            error "Terraform Init failed!"
                        }
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    withAWS(credentials: 'aws-credentials') {
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
                        def applyStatus = sh(script: 'terraform apply -input=false tfplan', returnStatus: true)
                        if (applyStatus != 0) {
                            error "Terraform Apply failed!"
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
            echo 'Terraform applied  executed successfully'
        }
        failure {
            echo 'Terraform apply or Ansible playbook failed'
        }
    }
}
