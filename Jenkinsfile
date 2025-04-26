pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('my-docker-hub') // Jenkins credentials ID
        DOCKER_IMAGE = "khaledmohamed447/jpetstore-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

     stages {
      
        stage('Docker Build') {
            steps {
                    script {
                    // Stop and remove containers using the image (if any)
                    sh '''
                    CONTAINER_IDS=$(docker ps -a -q --filter ancestor=${DOCKER_IMAGE}:latest)
                    if [ ! -z "$CONTAINER_IDS" ]; then
                      docker stop $CONTAINER_IDS
                      docker rm $CONTAINER_IDS
                    fi
                    '''
                    // Now safely remove images
                    sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
                    sh "docker rmi ${DOCKER_IMAGE}:latest || true"
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    '''
                }
            }
        }
        stage('Docker Push') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }

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
                        ansible-playbook ansible/deploy.yml -i inventory.yml -e "target_host=localhost use_sudo=true docker_tag=latest"
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




       // always {
        //     script {
        //         // Stop and remove containers using the image (if any)
        //         sh '''
        //         CONTAINER_IDS=$(docker ps -a -q --filter ancestor=${DOCKER_IMAGE}:latest)
        //         if [ ! -z "$CONTAINER_IDS" ]; then
        //           docker stop $CONTAINER_IDS
        //           docker rm $CONTAINER_IDS
        //         fi
        //         '''
        //         // Now safely remove images
        //         sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
        //         sh "docker rmi ${DOCKER_IMAGE}:latest || true"
        //     }
        // }
  // stage('Set up Maven Wrapper') {
  //           steps {
  //               script {
  //                   sh 'mvn -N io.takari:maven:wrapper' 
  //               }
  //           }
  //       }


        // stage('Build') {
        //     steps {
        //         sh './mvnw clean package'
        //     }
        // }
