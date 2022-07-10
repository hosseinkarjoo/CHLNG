output "kubernetes_workers_private_ip" {
  value = "${join(",", aws_instance.worker.*.private_ip)}"
}


output "kubernetes_master_private_ip" {
  value = "${aws_instance.master.private_ip}"
}

output "ECR_registry_address" {
  value = "${aws_ecr_repository.flask.repository_url}" 
}

output "LB_address" {
  value = "${aws_elb.app-lb.dns_name}" 
}

