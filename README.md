# Simple k8s
This project for simple k8s cluster local setup with IaC terraform.
* CNI cilium 
* secrets Vault
* ingress nginx 
* loggers loki
* CI/CD Argo



# Run
init modules
```bash
terraform init
```
setup 
```bash
terraform apply -auto-approve
```

destroy
```bash
terraform destroy
```