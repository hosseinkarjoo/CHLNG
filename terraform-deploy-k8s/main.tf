provider "kubernetes" {
  config_path    = "/root/.kube/config"
}


resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          image = "335090867831.dkr.ecr.us-east-1.amazonaws.com/flask:latest"    #this is the address of the ECR that should be replace with new one
          name  = "flask"
          port {
            container_port = "8080"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask-svc" {
  metadata {
    name = "flask-svc"
  }
  spec {
    selector = {
      app = "flask"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      node_port = 32000    # publishing the service with NodePort and an aws LB routes the traffic to all replicas
    }

    type = "NodePort"
  }
}

