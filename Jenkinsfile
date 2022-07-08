pipeline {
    agent any
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/CHLNG.git', branch: 'Docker'
            }
        }
        stage('build'){
            steps{
                sh'docker build -t hosseinkarjoo/flask:${BUILD_NUMBER} -t hosseinkarjoo/flask:latest .'
            }
        }
        stage('Stage-RUN'){
            steps{
                sh''' #!/bin/bash
                        if [ "$(docker ps -q -f name=flask)" ] 
                        then
                          docker container rm  flask --force
                          docker container run -d --name flask flask:latest
                        else
                          docker container run -d --name flask flask:latest
                        fi  
                '''
            }
        }
        stage('Unit-Test'){
            steps{
                sh'docker container exec flask pytest'
            }
        }
        stage ('Push Image to DockerHub') {
            steps {
                script {
                    withDockerRegistry([ credentialsId: "hub_credentialsId", url: "https://registry.hub.docker.com" ]) {
                        sh'docker push hosseinkarjoo/flask:${BUILD_NUMBER}'
                        sh'docker push hosseinkarjoo/flask:latest'
                    }
                }
            }
        }
    }
}
