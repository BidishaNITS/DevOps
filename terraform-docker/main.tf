terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"  # use the Docker provider
      version = "~> 3.0.2"            # a stable 3.x version
    }
  }
}

# Talks to your local Docker Desktop
provider "docker" {}

# Use your already-built local image app:1.0
resource "docker_image" "app" {
  name         = var.image_name
  keep_locally = true
}

# Runs a container like: docker run -p 8081:5000 app:1.0
resource "docker_container" "app" {
  name  = "terraform-app"
  image = docker_image.app.image_id

  ports {
    internal = var.container_port  # container’s port (Flask uses 5000)
    external = var.host_port       # host/laptop port (we’ll use 8081)
  }
}