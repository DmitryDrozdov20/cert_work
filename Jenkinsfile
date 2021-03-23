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
}

