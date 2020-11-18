pipeline {
  agent any
  environment {
    SVC_ACCOUNT_KEY = credentials('jenkins-gcp')
      PROJECT_ID = 'auto-infra-20201117-student3xi'
      DEFAULT_LOCAL_TMP = 'tmp/'
      ANSIBLE_USER = 'ubuntu'
      HOME = '/tmp'
  }

  stages {
    stage('Cleanup') {
      steps {
        cleanWs(deleteDirs: true)
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p creds'
    //    sh 'echo $SVC_ACCOUNT_KEY | base64 -di > ./creds/jenkins-sa.json'
        sh """
        sh cat <<EOF | base64 -di > ./creds/jenkins-sa.json
        $SVC_ACCOUNT_KEY
        EOF
        """.stripIndent()
      }
    }

    stage('Install Terraform') {
      steps {
        sh 'curl -o terraform.zip https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip'
        sh 'unzip terraform.zip'
      }
    }

    stage('TF Plan') {
      steps {
        sh './terraform init -reconfigure'
        sh './terraform plan -var project_id=$PROJECT_ID -var jenkins_workers_project_id=$PROJECT_ID -out myplan'
      }
    }

    stage('Approval') {
      steps {
        script {
          def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
        }

      }
    }

    stage('TF Apply') {
      steps {
        sh './terraform apply -input=false myplan'
      }
    }

    stage('Run Ansible playbook') {
      steps {
        withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'cicd-ssh-key', keyFileVariable: 'KEY')]) {
          sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml -i tf.gcp.yml --private-key ${KEY} -b -u $ANSIBLE_USER'
        }

      }
    }

  }
}
