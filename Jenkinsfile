pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }
    stages{
        stage('Git Checkout'){
            steps{
                git credentialsID: 'afade22e-6523-41e2-962e-4f7f4a53490e', url: 'https://github.com/DmitryDrozdov20/terraform-GC'
            }
        }
        stage('Terraform Init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform Apply'){
            steps{
                sh 'terraform apply --auto-aprove'
            }
        }
    }
}