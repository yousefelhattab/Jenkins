pipeline {
    agent any
  
    triggers {
        // Trigger pipeline on push from GitHub webhook
        githubPush()
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        stage('Initialize Terraform') {
            steps {
                echo 'Initializing Terraform...'
                sh '''
                    terraform init
                '''
            }
        }
        stage('Plan Terraform') {
            steps {
                echo 'Planning Terraform...'
                sh '''
                    terraform plan 
                '''
            }
        }
        stage('Apply Terraform') {
            steps {
                echo 'Applying Terraform to create EC2 instance...'
                sh '''
                    terraform apply -auto-approve tfplan
                '''
            }
        }
        stage('Run Ansible Script') {
            steps {
                echo 'Running Ansible Playbook...'
                sh '''
                    ansible-playbook -i inventory playbook.yml
                '''
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

