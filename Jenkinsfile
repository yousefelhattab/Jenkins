pipeline{
    agent any
    stages{
        stage('checkout from GIT'){
            steps{
               git branch: 'main', url: 'https://github.com/yousefelhattab/Jenkins'
            }
        }
        stage('Terraform Init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform Apply'){
           steps{
                sh 'terraform apply --auto-approve'
           }
        }
    }   
}
