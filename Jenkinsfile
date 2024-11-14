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
                        // Run the EC2 instance creation command
                        def result = aws(
                            command: 'ec2 run-instances',
                            arguments: [
                                "--image-id ${amiId}",
                                "--count 1",
                                "--instance-type ${instanceType}",
                                "--key-name ${keyName}",
                                "--security-group-ids ${securityGroup}",
                                "--tag-specifications '${tagSpecifications}'"
                            ].join(' ')
                        )
                        
                        // Log output and check for issues
                        echo "AWS CLI Output: ${result.stdout ?: 'No standard output'}"
                        echo "AWS CLI Error: ${result.stderr ?: 'No error output'}"
                        
                        // Validate successful response
                        if (result.stderr) {
                            error "Failed to create EC2 instance: ${result.stderr}"
                        } else {
                            echo "EC2 Instance created successfully!"
                            echo "Response: ${result.stdout}"
                        }
                    }
                }
            }
        }
    }
}
