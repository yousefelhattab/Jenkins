pipeline {
    agent any

    environment {
       AWS_CREDENTIALS_ID = 'aws-access-key' 
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git 'https://github.com/yousefelhattab/Jenkins.git'  // Replace with your repo URL
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                echo 'Initializing Terraform...'
                sh 'terraform init'
                echo 'Applying Terraform plan...'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    // Fetch the public IP of the EC2 instance
                    def instance = sh(script: 'terraform output -json instance_public_ip', returnStdout: true).trim()
                    echo "EC2 instance public IP: ${instance}"
                    env.EC2_PUBLIC_IP = instance
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                echo 'Running Ansible playbook...'
                sh """
                    ansible-playbook -i ${EC2_PUBLIC_IP}, -u ec2-user --private-key /path/to/private-key setup.yml
                """
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Terraform state...'
            sh 'terraform destroy -auto-approve'
        }
    }
}
