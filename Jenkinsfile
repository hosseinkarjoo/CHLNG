pipeline {
    agent any
    environment {
        registry = "026843750572.dkr.ecr.us-east-1.amazonaws.com/flask"
    }
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/CHLNG.git', branch: 'K8s-terraform'
            }
        }
        stage('build docker image'){
            steps{
                sh'docker build --build-arg GITHASH=$(git rev-parse HEAD) --build-arg GITREPO=$(git config --get remote.origin.url) -t ${registry}:${BUILD_NUMBER} -t ${registry}:latest .'
            }
        }
        stage('Stage-RUN'){
            steps{
                sh''' #!/bin/bash
                        if [ "$(docker ps -qa -f name=flask)" ] 
                        then
                          docker container rm  flask --force
                          docker container run -d --name flask ${registry}:latest
                        else
                          docker container run -d --name flask ${registry}:latest
                        fi  
                '''
            }
        }
        stage('Unit-Test'){
            steps{
                sh'docker container exec flask pytest'
            }
        }
        stage ('Push Image to ECR') {
            steps {
                script {
                    sh'sudo aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}'    
                    sh'docker push ${registry}:${BUILD_NUMBER}'
                    sh'docker push ${registry}:latest'
                }
            }
        }
        stage('Remove the Docker Container'){
            steps{
                sh'docker container rm  flask --force'
            }
        }
        stage('run deployment with TF'){
            steps{
                sh'cd ./terraform-deploy-k8s && terraform init'
                sh'cd ./terraform-deploy-k8s && sudo terraform apply -auto-approve'
            }
        }
    }
}
