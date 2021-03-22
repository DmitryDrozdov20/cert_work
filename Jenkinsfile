pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }
    
    stages{
        stage('Git Checkout'){
            steps{
                git credentialsId: 'afade22e-6523-41e2-962e-4f7f4a53490e', url: 'https://github.com/DmitryDrozdov20/terraform-GC'
            }
        }
        stage('Terraform Init'){
            steps{
                sh 'terraform init'
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply'){
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
    }

    docker {
      image 'fbird75/jenkins-ansible-agent'
      args  '-v /var/run/docker.sock:/var/run/docker.sock -u 0:0'
      registryCredentialsId '4f5b1636-2d4f-4dfc-83ef-d4a856c0788f'
    }
}

