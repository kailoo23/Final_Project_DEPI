pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('my-docker-hub') // Jenkins credentials ID
        DOCKER_IMAGE = "khaledmohamed447/jpetstore-app"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/khaledmohamed447/jpetstore-repo.git', branch: 'main'
            }
        }

        stage('Set up Maven Wrapper') {
            steps {
                script {
                    sh 'mvn -N io.takari:maven:wrapper' 
                }
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests=false'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
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
                        ansible-playbook ansible/deploy.yml
                    '''
                }
            }
        }
    }

    post {
        always {
            sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
            sh "docker rmi ${DOCKER_IMAGE}:latest || true"
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}




    // stage('Test') {
        //     steps {
        //         sh './mvnw test'
        //     }
        // }


// pipeline {
//     agent any // Runs on your local VM's Jenkins

//     environment {
//         DOCKERHUB_CREDENTIALS = credentials('my-docker-hub')
//         DOCKER_IMAGE = "khaledmohamed447/jpetstore"
//         DOCKER_TAG = "${env.BUILD_NUMBER}"
//     }

//     stages {
//         stage('Clone') {
//             steps {
//                 git url: 'https://github.com/khaledmohamed447/jpetstore-repo.git', branch: 'main' // Replace with your actual repo URL
//             }
//         }

//         stage('Build') {
//             steps {
//                 sh './mvnw clean package -DskipTests=false'
//             }
//         }

//         stage('Docker Build') {
//             steps {
//                 sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
//             }
//         }

//         stage('Docker Push') {
//             steps {
//                 sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
//                 sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
//                 sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
//                 sh "docker push ${DOCKER_IMAGE}:latest"
//             }
//         }

//     //     stage('Deploy') {
//     //         steps {
//     //             withCredentials([usernamePassword(credentialsId: 'my-docker-hub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
//     //                 // Pass EC2 public IP as an extra variable (set this in Jenkins environment or manually)
//     //                 sh 'ansible-playbook ansible/deploy.yml -e "target_host=${EC2_PUBLIC_IP}"'
//     //             }
//     //         }
//     //     }
//     // }

//     stage('Deploy') {
//         steps {
//             withCredentials([usernamePassword(credentialsId: 'my-docker-hub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
//                 // For local deployment, no need for target_host var
//                 sh '''
//                     export DOCKERHUB_USERNAME=$DOCKERHUB_USERNAME
//                     export DOCKERHUB_PASSWORD=$DOCKERHUB_PASSWORD
//                     ansible-playbook ansible/deploy.yml
//                 '''
//             }
//         }
//     }
//     post {
//         always {
//             sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
//             sh "docker rmi ${DOCKER_IMAGE}:latest || true"
//         }
//         success {
//             echo 'Pipeline completed successfully!'
//         }
//         failure {
//             echo 'Pipeline failed.'
//         }
//     }
// }
