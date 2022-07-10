Install requirments and provision Infrastructure on AWS
--------------------------------------------
- run install_req.sh > it asks for access_key and Secret_key of the aws account. this script brings up and provision Infrastructure on aws with TF, configure a Kubernetes cluster with One Master and 3 Workers with Kubeadm via Ansible and install a jenkns server on the Bastion host.all the instances are in a private network and only the bastion server has public IP address.Bastion host has kubectl(to connect to cluster) and docker.

- after complition run : cat inventory.ini

- take the Bastion host public ip address and open it in a browser with port :8080 and configure your jenkins server

- you can connect to bstion host with ec2-user@<bastion public ip> and the public key of your local host has benen added to the instances.

- create a "pipelne app" and select "pipeline from scm" and give it the Git repository and branch name (K8s-terraform) to pipeline.

- on the local run : terraform output and take the "ECR address" and the "LB address".

- modify Jenksfile and ./terraform-deploy-kubernetes/main.tf and replace the old ECR address with the new one.

- run the pipeline in jenkins and after compeletion go to the LB address with http and port 80.
