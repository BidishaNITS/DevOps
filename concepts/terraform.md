
## What is Terraform?
Terraform is **Infrastructure as Code (IaC)**.  
Instead of manually running `docker run`, `kubectl apply`, or cloud commands, you **declare your infrastructure in `.tf` files** and let Terraform create/update/destroy it.  

---

## Core Concepts

- **Provider** → plugin that talks to a platform (Docker, Kubernetes, AWS, etc.).  
- **Resource** → actual thing you manage (`docker_container`, `docker_image`, `aws_instance`, etc.).  
- **Workflow**  
  1. `terraform init` → download plugins  
  2. `terraform plan` → show what changes Terraform *would* make  
  3. `terraform apply` → actually make the changes  
  4. `terraform destroy` → remove resources  

--- 

## What I did in this project

- Used **Docker provider** (kreuzwerker/docker).  
- Declared two resources:  
  - `docker_image.app` → uses my already built `app:1.0` image  
  - `docker_container.app` → runs the image on **host port 8081** → mapped to **container port 5000**  

This is the IaC version of running:  
```bash
docker run -p 8081:5000 app:1.0


⸻

Project Structure

terraform-docker/
├── main.tf        # main config (provider + resources)
├── variables.tf   # input variables
├── outputs.tf     # outputs (print app URL)


⸻

Commands I used

# Go inside terraform-docker folder
cd terraform-docker

# Download provider plugins (creates .terraform + lockfile)
terraform init

# See what Terraform will do
terraform plan

# Apply the changes (create container)
terraform apply -auto-approve

# Destroy container when done
terraform destroy -auto-approve


⸻

Example Output

Plan: 2 to add, 0 to change, 0 to destroy.
Outputs:
app_url = "http://localhost:8081"

Now I can test in browser:
http://localhost:8081

⸻

Troubleshooting
	•	Error: undeclared variable
→ I forgot variables.tf. Added:

variable "image_name" {
  default = "app:1.0"
}
variable "container_port" {
  default = 5000
}
variable "host_port" {
  default = 8081
}


	•	Unwanted files in Git
Added .gitignore in repo root:

# Terraform
.terraform/
*.tfstate
*.tfstate.backup



⸻

Key Takeaways
	•	IaC makes infra repeatable, versioned, reviewable.
	•	Provider = platform plugin (Docker, AWS, K8s).
	•	Resource = unit of infra.
	•	plan → apply → destroy = Terraform lifecycle.
	•	This repo shows IaC even without cloud 

⸻

