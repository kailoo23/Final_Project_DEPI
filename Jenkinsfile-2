pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('my-docker-hub') // Jenkins credentials ID
        DOCKER_IMAGE = "khaledmohamed447/jpetstore-app:latest"
        DOCKER_TAG = "latest" // Use a specific tag or 'latest'
    }
    

    stages {

        stage('Deploy (Local with Ansible)') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'my-docker-hub',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        export DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME
                        export DOCKERHUB_PASSWORD=$DOCKERHUB_PASSWORD
                        ansible-playbook ansible/deploy.yml -e "docker_tag=$DOCKER_TAG"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
