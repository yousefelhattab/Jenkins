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
        stage('Capture EC2 Public IP') {
            steps {
                script {
                    // Capture the public IP of the EC2 instance
                    def ec2PublicIP = sh(script: 'terraform output -raw ec2_public_ip', returnStdout: true).trim()
                    echo "EC2 Public IP: ${ec2PublicIP}"

                    // Create a dynamic Ansible inventory file
                    writeFile(file: 'inventory.ini', text: """
[ec2_instance]
${ec2PublicIP}

[ec2_instance:vars]
ansible_ssh_user=ec2-user
ansible_ssh_private_key_file=/path/to/your/ansible.pem
""")
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                script {
                    // Run the Ansible playbook using the generated inventory file
                    ansiblePlaybook(
                        playbook: 'install_package.yml',
                        inventory: 'inventory.ini'
                    )
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Terraform applied and Ansible playbook executed successfully'
        }
        failure {
            echo 'Terraform apply or Ansible playbook failed'
        }
    }
}
