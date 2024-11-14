pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' // Set your AWS region
    }
    stages {
        stage('Launch EC2 Instance') {
            steps {
                script {
                    // Configuration variables
                    def amiId = 'ami-063d43db0594b521b'
                    def instanceType = 't2.micro'
                    def keyName = 'ansible'
                    def securityGroup = 'sg-0eb11d9a0361848f3'
                    def tagSpecifications = "ResourceType=instance,Tags=[{Key=Name,Value=Jenkins-EC2}]"

                    withAWS(credentials: 'aws-credentials', region: AWS_REGION) {
                        try {
                            def result = sh(
                                script: """
                                    aws ec2 run-instances \
                                    --image-id ${amiId} \
                                    --count 1 \
                                    --instance-type ${instanceType} \
                                    --key-name ${keyName} \
                                    --security-group-ids ${securityGroup} \
                                    --tag-specifications '${tagSpecifications}' \
                                    --region ${AWS_REGION}
                                """,
                                returnStdout: true
                            ).trim()

                            echo "EC2 Instance created successfully!"
                            echo "AWS CLI Output: ${result}"
                        } catch (Exception e) {
                            error "Failed to create EC2 instance: ${e.getMessage()}"
                        }
                    }
                }
            }
        }
    }
}

