# Terraform AWS Tasks

![Terraform](https://miro.medium.com/1*SZI5QIEZEYUUQuB4pQfTjw.gif)


🚀 Terraform Mastery & AWS Automation
Welcome to my Terraform journey! This repository is a collection of hands-on tasks and labs where I’ve automated AWS infrastructure using Infrastructure as Code (IaC). From basic resource provisioning to advanced modular architecture, this repo covers the core pillars of a DevOps Engineer's toolkit.

🛠️ Key Topics Covered
I’ve successfully implemented the following Terraform concepts:

Modular Architecture: Building reusable and scalable code using Terraform Modules (e.g., Static Website Hosting on S3).

Security & Secret Management: Using AWS Secrets Manager with sensitive variables to protect credentials.

Multi-Environment Workflows: Managing separate environments (Dev/Prod) using Terraform Workspaces.

Dynamic Resource Provisioning: Using meta-arguments like count and for_each for efficient resource scaling.

Automation & Lifecycle: * Provisioners (local-exec): Automating local logging and post-deployment tasks.

Lifecycle Rules: Managing resource behavior (ignore changes, prevent destroy).

State Management: Handling .tfstate files and backend configurations.

📂 Project Structure
/modules: Reusable components (S3, Networking, etc.)

/environments: Workspace-specific configurations.

main.tf: The root orchestrator.

⚙️ Tools Used
Terraform CLI

AWS (S3, Secrets Manager, API Gateway, CloudWatch)

LocalStack (for local cloud simulation)



