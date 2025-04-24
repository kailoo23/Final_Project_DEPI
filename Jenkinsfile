pipeline {
    agent any // Runs on your local VM's Jenkins

    environment {
        DOCKERHUB_CREDENTIALS = credentials('my-docker-hub')
        DOCKER_IMAGE = "khaledmohamed447/jpetstore"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'https://github.com/khaledmohamed447/jpetstore-repo.git', branch: 'main' // Replace with your actual repo URL
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

        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-docker-hub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    // Pass EC2 public IP as an extra variable (set this in Jenkins environment or manually)
                    sh 'ansible-playbook ansible/deploy.yml -e "target_host=${EC2_PUBLIC_IP}"'
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
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
