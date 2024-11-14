pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' // Set your AWS region
    }
    stages {
        stage('Launch EC2 Instance') {
            steps {
                script {
                    // Replace with your AMI ID, instance type, and security group
                    def amiId = 'ami-063d43db0594b521b'
                    def instanceType = 't2.micro'
                    def keyName = 'ansible'
                    def securityGroup = 'sg-0eb11d9a0361848f3'

                    withAWS(credentials: 'aws-credentials', region: AWS_REGION) {
                        def result = aws(
                            command: 'ec2 run-instances',
                            arguments: [
                                "--image-id ${amiId}",
                                "--count 1",
                                "--instance-type ${instanceType}",
                                "--key-name ${keyName}",
                                "--security-group-ids ${securityGroup}",
                                "--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Jenkins-EC2}]'"
                            ].join(' ')
                        )
                        echo "EC2 Instance Created: ${result}"
                    }
                }
            }
        }
    }
}
