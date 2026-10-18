terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Скачивание официального образа Nginx
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# Декларативное создание и запуск контейнера
resource "docker_container" "web_server" {
  image = docker_image.nginx.image_id
  name  = "terraform-managed-site"

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "${path.cwd}/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }
}
