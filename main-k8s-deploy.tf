provider "kubernetes" {
  config_path    = "~/.kube/config"
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
          image = "937945817386.dkr.ecr.us-east-1.amazonaws.com/flask:latest"
          name  = "flask"
          ports {
            containerPort = "8080"
          }
        }
      }
    }
  }
}
