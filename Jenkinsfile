pipeline {
    agent any
    environment {
        registry = "cloud.canister.io:5000/hosseinkarjoo/flask"
    }
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/CHLNG.git', branch: 'Docker'
            }
        }
        stage('build'){
            steps{
                sh'docker build -t ${registry}:${BUILD_NUMBER} -t ${registry}:latest .'
            }
        }
        stage('Stage-RUN'){
            steps{
                sh''' #!/bin/bash
                        if [ "$(docker ps -qa -f name=flask)" ] 
                        then
                          docker container rm  flask --force
                          docker container run -d --name flask -p 8090:8080 ${registry}:latest
                        else
                          docker container run -d --name flask -p 8090:8080 ${registry}:latest
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
                    withDockerRegistry([ credentialsId: "hub_credentialsId", url: "http://registry.hub.docker.com" ]) {
                        sh'docker push ${registry}:${BUILD_NUMBER}'
                        sh'docker push ${registry}:latest'
                    }
                }
            }
        }
    }
}
