# Junior DevOps Showcase

This repository is my personal DevOps  project demonstrating practical skills in infrastructure automation, configuration management, container orchestration, CI/CD pipelines, and security testing.

---

# Project Summary

I designed and implemented a multi-environment Kubernetes cluster deployment from the ground up using Ansible.

---

## Infrastructure Provisioning

- Manual provisioning of virtual machines and networking resources  
- Automatic provisioning of AWS resources using Terraform  

---

## Configuration Management

- Used Ansible to configure Jenkins server, Kubernetes control plane, and worker node  
- Automated installation of Kubernetes components, container runtime, TLS certificate management, and system tuning  

---

## Container Orchestration

- Deployed a simple static web application on a Kubernetes cluster with multi-node architecture  
- Leveraged Helm charts for package management and templated configuration  

---

## GitOps Deployment

- Integrated ArgoCD to implement GitOps workflows  
- Enabled declarative continuous deployment of Helm charts from GitHub repositories  

---

## CI/CD Pipelines

- Created automated Jenkins pipelines to build, test, and deploy applications  
- Included stages for static code analysis, report publishing, and dynamic application security testing (DAST) with OWASP ZAP  

---

## Security and Certificates

- Automated generation and renewal of Kubernetes TLS certificates using OpenSSL and Ansible  
- Integrated security scanning within CI/CD pipelines to identify vulnerabilities  

---

## Monitoring & Observability

- Deployed a centralized monitoring stack based on **Prometheus**, **Grafana**, and **Loki**  
- Installed **node-exporter** and **promtail** on each node for system metrics and logs collection  
- Integrated **kube-state-metrics** and **cAdvisor** for detailed Kubernetes cluster and container-level visibility  
- Configured Prometheus to scrape Kubernetes and system metrics, providing real-time insights into infrastructure and workloads  
- Visualized metrics and logs in Grafana through custom dashboards for system, application, and Kubernetes-level monitoring  

---

## Tools & Technologies

- **Terraform** — Infrastructure-as-Code  
- **Ansible** — Automation & Configuration Management  
- **Kubernetes** — Cluster Orchestration  
- **Helm** — Templated Charts & Package Management  
- **ArgoCD** — GitOps Continuous Deployment  
- **Jenkins** — Pipeline Automation  
- **Prometheus**, **Grafana**, **Loki** — Monitoring & Logging Stack  
- **kube-state-metrics**, **node-exporter**, **cAdvisor**, **promtail** — Cluster & Node Visibility  
- **Docker** & Container runtimes  
- **Linux System Administration** (CentOS)  

---
