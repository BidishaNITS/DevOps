variable "image_name" {
  description = "Docker image to run"
  type        = string
  default     = "app:1.0"
}

variable "container_port" {
  description = "Port inside the container"
  type        = number
  default     = 5000
}

variable "host_port" {
  description = "Port on your laptop"
  type        = number
  default     = 8081
} 