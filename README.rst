I used AWS Sandboxes for this assignment.

- The first part "a little bit of programing" can be found in branch "http-service"
all the items are implemented.

- The secound part "CI" can be found in "Docker" branch. in this part everything is implemented except the last task that says "Save your Docker image somewhere you can retrieve it from later". 
because i am using AWS ECR as docker image registry and i have to create them dynamicly (sandboxes lives for only 4 hours) and i didn`t go through the proccess of creating a private registry (nexus or docker-reg) because it wasn`t the part of assignments.
however i am building my image in other steps again and then i push them into ECR to pull it later.

- The third part is "CD". for presentation perposes i created a script that can be run on Centos 7 to provision an infrastructure for this part on AWS. i used TF to provision the infrastruture and instances and VPCs and ...
and used ansible to bring up a kubernetes cluster with kubeadm and Jenkins instance to run pipelines.
if you need me to present and demo my deployment this script that runs TF and ansible can provision the infrastructure in 10 minutes.
It is in two parts, On branch "K8s" it runs a pipeline to kubernetes with kubernetis manifests (yml) and the Branch "K8s-terraform" deploy to the cluster via terraform.

I only created a deployment and a Nodeport for my http-service and i didn`t go any further (like Ingress or probes , ...) 
but if it is a part of the process and it is nesessary please tell me and i will do it ASAP.

* answer to task CD.part4 : as far as i know the things that you asked for a graceful shutdown are defaults (i. terminationGracePeriodSeconds: 30 is the default, ii. as soon as the kubeapi gets the termination order it will remove the endpoints to the pod or container so no more new requests can reach the pod, iii. after 30 secounds of GracePeriod container will recieve a SIGKILL and will be killed instantly )
* answer to K8s Debugging: the service selector is diffrent from the pod lable and the service can`t relate to the pods and send traffic to pods (contaner lables is "app: nginx" and the service selector trys to find "app: wrong_nginx")
* ansert to GCP Architecture: best service to run containers that are managed is Google Cloud Run which the similar service in AWS is fargate.
