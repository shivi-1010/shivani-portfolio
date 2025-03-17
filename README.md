# Shivani Varu's Portfolio Website - CI/CD Pipeline

This repository contains the source code for Shivani Varu's portfolio website along with a modern CI/CD pipeline for local deployment using Docker, Kubernetes (Minikube), ArgoCD, Ansible, and Terraform.

## Prerequisites

- Windows 11
- WSL2
- Docker Desktop
- VS Code
- Git

## Setup Instructions

1. Clone this repository:
   ```

   git clone https://github.com/shivi-1010/shivani-portfolio.git
   cd shivani-portfolio
   ```

2. Install required tools (if not already installed):
   ```
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   
   choco install docker-desktop minikube kubernetes-cli terraform vscode git -y
   
   wsl --install
   ```

3. Run the Ansible playbook to deploy everything:
   ```
   cd ansible
   ansible-playbook deploy-portfolio.yaml
   ```

4. Access the portfolio website:
   - Open http://portfolio.local in your browser

5. Access ArgoCD dashboard:
   - Open https://localhost:8080 in your browser
   - Username: admin
   - Password: (displayed in the Ansible output)

## Making Changes

1. Modify your website files
2. Rebuild and reload the Docker image:
   ```
   docker build -t shivani-portfolio:latest -f docker/Dockerfile .
   minikube image load shivani-portfolio:latest
   ```
3. ArgoCD will automatically detect and apply changes

## Architecture

- **Docker**: Containerizes the portfolio website
- **Kubernetes (Minikube)**: Orchestrates containers locally
- **ArgoCD**: Implements GitOps-based continuous deployment
- **Ansible**: Automates the setup process
- **Terraform**: Manages Kubernetes resources as code
- **GitHub Actions**: Automates CI pipeline
- **NGINX Ingress**: Manages traffic within Minikube

## Repository Structure

```
ShivaniVaru-Digital-Portfolio/
├── ansible/                  # Ansible playbooks for automation
├── docker/                   # Docker configuration
├── kubernetes/               # Kubernetes manifests
├── terraform/                # Terraform configuration
├── .github/workflows/        # GitHub Actions CI pipeline
├── assets/                   # Website assets (CSS, JS, images)
└── index.html                # Main portfolio HTML file
```

## Troubleshooting

- If the website doesn't load, check Minikube status: `minikube status`
- Verify pods are running: `kubectl get pods -n portfolio`
- Check ingress configuration: `kubectl get ingress -n portfolio`
- View logs: `kubectl logs -n portfolio deployment/shivani-portfolio`
```

## 9. Running the Pipeline

To deploy the portfolio website with the CI/CD pipeline:

```bash
cd ShivaniVaru-Digital-Portfolio/ansible
ansible-playbook deploy-portfolio.yaml
