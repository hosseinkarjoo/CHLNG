Install requirements and provision Infrastructure on AWS
--------------------------------------------
- run install_req.sh > it asks for access_key and secret_key of the AWS account.  this script brings up and provision Infrastructure on AWS with TF, configure a Kubernetes cluster with One Master and 3 Workers with Kubeadm via Ansible and install a Jenkins server on the Bastion host.  All the instances are in a private network and only the bastion server has public IP address.  Bastion host has kubectl (to connect to cluster) and Docker.

- after completion run : cat inventory.ini

- take the Bastion host public IP address and open it in a browser with port :8080 and configure your Jenkins server

- you can connect to bastion host with ec2-user@<bastion public IP> and the public key of your local host has been added to the instances.

- create a "pipeline app" and select "pipeline from SCM" and give it the Git repository and branch name (K8s-terraform) to pipeline.

- on the local run : terraform output and take the "ECR address" and the "LB address".

- modify Jenkinsfile and ./terraform-deploy-kubernetes/main.tf and replace the old ECR address with the new one.

- run the pipeline in Jenkins and after completion go to the LB address with http and port 80.
This branch uses terraform to deploy to Kubernetes.
