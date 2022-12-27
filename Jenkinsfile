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
        dir('tentech_project/tf/') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform plan') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('tentech_project/tf/') {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform apply') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('tenetch_project/tf') {
          sh 'terraform apply --auto-approve'
        }
      }
    }

    stage('Handle TF outputs') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('tentech_project/helperScripts/') {
          sh './manageOutputs.sh'
        }
      }
    }

    stage('Execute ansible') {
      when {
        environment name: 'ExecuteAction', value: 'build'
      }
      steps {
        dir('tentech_project/ansible/') {
          sh 'ansible-playbook ./playbooks/wordpress.yml'
        }
      }
    }
  }
}


