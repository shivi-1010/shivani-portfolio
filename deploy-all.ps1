# Deploy both local development environment and GitHub Pages

# 1. Local Development Environment
Write-Host "Setting up local development environment..." -ForegroundColor Green

# Start Minikube
minikube start --driver=hyperv

# Enable Ingress
minikube addons enable ingress

# Build Docker image
docker build -t shivani-portfolio:latest -f docker/Dockerfile .

# Load image into Minikube
minikube image load shivani-portfolio:latest

# Initialize and apply Terraform
Set-Location -Path .\terraform
terraform init
terraform apply -auto-approve
Set-Location -Path ..

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply ArgoCD application
kubectl apply -f kubernetes/argocd-app.yaml

# Get Minikube IP and add to hosts file
$minikubeIp = minikube ip
$hostEntry = "$minikubeIp portfolio.local"
$hostsFile = "$env:windir\System32\drivers\etc\hosts"
$hosts = Get-Content $hostsFile
if ($hosts -notcontains $hostEntry) {
  Add-Content -Path $hostsFile -Value $hostEntry -Force
}

# Get ArgoCD password
$argocdPasswordBase64 = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
$argocdPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($argocdPasswordBase64))
Write-Host "ArgoCD Username: admin" -ForegroundColor Cyan
Write-Host "ArgoCD Password: $argocdPassword" -ForegroundColor Cyan

# Start port forwarding for ArgoCD
Start-Process -NoNewWindow kubectl -ArgumentList "port-forward svc/argocd-server -n argocd 8080:443"

# 2. GitHub Pages Deployment
Write-Host "Deploying to GitHub Pages..." -ForegroundColor Green

# Commit and push changes
git add .
git commit -m "Update portfolio via PowerShell script"
git push origin main

# Install dependencies
npm install

# Build and deploy
npm run build
npm run deploy

Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "Local development portfolio website: http://portfolio.local" -ForegroundColor Yellow
Write-Host "ArgoCD dashboard: https://localhost:8080" -ForegroundColor Yellow
Write-Host "Public portfolio website: https://shivi-1010.github.io/shivani-portfolio" -ForegroundColor Yellow
