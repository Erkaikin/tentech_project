/* groovylint-disable CompileStatic */
pipeline {
  agent any

  parameters {
    choice(
      name: 'ExecuteAction', choices: [
        'build', 'destroy'
      ],
      description: 'Which action to take'
    )
  }

  stages {
    stage('Terraform init') {
      steps {
        dir('terraform-simple') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform plan') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('terraform-simple') {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform apply') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('terraform-simple') {
          sh 'terraform apply --auto-approve'
        }
      }
    }

    stage('Handle TF outputs') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('helperScripts') {
          sh './manageOutputs.sh'
        }
      }
    }

    stage('Execute ansible') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('ansible') {
          sh 'ansible-playbook ./playbooks/wordpress.yml'
        }
      }
    }
  }
}


