pipeline {
    agent any
    environment {
        registry = "335090867831.dkr.ecr.us-east-1.amazonaws.com/flask"   //This should be replace with new ECR address
    }
    stages {
        stage('Clone Git Project') {
            steps {
                git url: 'https://github.com/hosseinkarjoo/CHLNG.git', branch: 'K8s'
            }
        }
        stage('build docker image'){   // in thi step last git hash  and git repo name will be passed into container as varibale
            steps{
                sh'docker build --build-arg GITHASH=$(git rev-parse HEAD) --build-arg GITREPO=$(git config --get remote.origin.url) -t ${registry}:${BUILD_NUMBER} -t ${registry}:latest .'
            }
        }
        stage('Stage-RUN'){  // checks to see if container existes and if it exists remove it first
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
                sh'docker container exec flask pytest'  // runs the unit tests inside of the container
            }
        }
        stage ('Push Image to ECR') {  // push image to registry after tests and vaidations
            steps {
                script {
                    sh'sudo aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${registry}'    //login to ECR with awscli
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
        stage('run deployment'){   //checks to see if the deployment exists use a rolling update to re pull the image and update the pods. with new image
            steps{
                sh'pwd'
                sh''' #!/bin/bash
                        if sudo kubectl get deploy flask
                        then
                          sudo kubectl apply -f flask.yml
                          sudo kubectl rollout restart deploy flask 
                        else
                          sudo kubectl apply -f flask.yml
                        fi
                  '''
            }
        }
    }
}
