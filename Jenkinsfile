pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }

    stage('Copy GCP authentication json to workspace on Jenkins agent') {
      steps {
        //Inject GCP authentication json to agent
        withCredentials([file(credentialsId: 'silken-realm-307723', variable: 'gcp_auth')]) {
          sh 'cp \$gcp_auth silken-realm-307723-75330dcabcd8.json'
        }
      }  
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
            }
        }
        stage('Terraform Apply'){
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
    }
}