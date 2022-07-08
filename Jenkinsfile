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
                sh'docker build -t flask:${BUILD_NUMBER} -t flask:latest .'
            }
        }
        stage('Stage-RUN'){
            steps{
                sh''' #!/bin/bash
                        if [ "$(docker ps -q -f name=flask)" ] 
                        then
                          docker container rm  flaks --foce
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
                    docker.withRegistry('https://registry.hub.docker.com', 'hub_credentialsId') {
                        hosseinkarjoo/flask.push("${BUILD_NUMBER}")
                        hosseinkarjoo/flask.push("latest")
                    }
                }
            }
        }
    }
}
