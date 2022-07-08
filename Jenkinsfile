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
                        if [ "$(docker ps -q -f name=flask)" ]; then
                          docker container stop flask
                          docker container run -d --name flask flask:latest
                        else
                          docker container run -d --name flask flask:latest
                '''
            }
        }
        stage('Unit-Test'){
            steps{
                sh'docker container exec flask pytest'
            }
        }
    }
}
