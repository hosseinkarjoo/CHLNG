I used AWS Sandboxes for this assignment.

- The first part "a little bit of programing" can be found in branch "http-service"


- The second part "CI" can be found in "Docker" branch.  in this part everything is implemented except the last task that says "Save your Docker image somewhere you can retrieve it from later". Because I am using AWS ECR as docker image registry and I have to create them dynamically (sandboxes lives for only 4 hours) and I didn`t go through the process of creating a private registry (nexus or docker-reg) because it wasn`t the part of assignments. However I am building my image in other steps again and then i push them into ECR to pull it later.


- The third part is "CD". for presentation purposes I created a script that can be run on Centos 7 to provision an infrastructure for this part on AWS.  I used TF to provision the infrastructure and instances and VPCs and etc.  and used ansible to bring up a Kubernetes cluster with Kubeadm and Jenkins instance to run pipelines. If you need me to present and demo my deployment this script that runs TF and ansible can provision the infrastructure in 20 minutes MAX. It is in two parts, on branch "K8s" it runs a pipeline to Kubernetes with Kubernetes manifests (yml) and the branch "K8s-terraform" deploy to the cluster via terraform. 

I only created a deployment and a Nodeport for my http-service and I didn`t go any further (like Ingress or probes , etc.)  
But if it is a part of the process and it is necessary please tell me and I will do it ASAP.

* answer to task CD.part4 : as far as I know the things that you asked for a graceful shutdown are defaults (i. terminationGracePeriodSeconds: 30 is the default, ii. as soon as the Kubeapi gets the termination order it will remove the endpoints to the pod or container so no more new requests can reach the pod, iii. after 30 seconds of GracePeriod container will receive a SIGKILL and will be killed instantly )
* answer to K8s Debugging: the service selector is different from the pod label and the service can`t relate to the pods and send traffic to pods (container labels is "app: nginx" and the service selector tries to find "app: wrong_nginx")
* answer to GCP Architecture: best service to run containers that are managed is Google Cloud Run which the similar service in AWS is Fargate.
