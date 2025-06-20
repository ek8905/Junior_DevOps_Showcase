# Junior DevOps Showcase

This repository is my personal DevOps  project demonstrating practical skills in infrastructure automation, configuration management, container orchestration, CI/CD pipelines, and security testing.

---

## Project Summary

I designed and implemented a multi-environment Kubernetes cluster deployment from the ground up using Ansible.

- **Infrastructure Provisioning:**  
  Manual provisioning of virtual machines and networking resources and automatic  provisioning of AWS resources using **Terraform**

- **Configuration Management:**  
  Used **Ansible** to configure Jenkins server, Kubernetes control plane and worker node, including installation of Kubernetes components, container runtime, TLS certificate management, and system tuning.

- **Container Orchestration:**  
  Deployed a simple static web application on a Kubernetes cluster with multi-node architecture, leveraging **Helm** charts for package management and templated configuration.

- **GitOps Deployment:**  
  Integrated **ArgoCD** to implement GitOps workflows, enabling declarative continuous deployment of the Helm charts from GitHub repositories.

- **CI/CD Pipelines:**  
  Created automated Jenkins pipelines to build, test, and deploy applications. Included stages for static code analysis, publish reports, and dynamic application security testing (DAST) with **OWASP ZAP**.

- **Security and Certificates:**  
  Automated generation and renewal of Kubernetes TLS certificates using OpenSSL and Ansible. Integrated security scanning in CI/CD to identify vulnerabilities.

---

## Tools & Technologies

- Terraform  
- Ansible  
- Kubernetes   
- Helm (templated charts with environment-specific values)  
- ArgoCD (GitOps continuous deployment)  
- Jenkins (pipeline automation)  
- Docker & container runtimes  
- Linux system administration (CentOS)

---

## Key Learnings

- Designing infrastructure-as-code that is modular and environment-agnostic  
- Managing Kubernetes clusters securely with automated certificate handling  
- Writing reusable Ansible roles and playbooks for  setups  
- Building reliable CI/CD pipelines with integrated security gates  
- Using GitOps principles to simplify application deployment and management  
