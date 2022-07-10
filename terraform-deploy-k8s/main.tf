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
          image = "026843750572.dkr.ecr.us-east-1.amazonaws.com/flask:latest"
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
      node_port = 32000
    }

    type = "NodePort"
  }
}

