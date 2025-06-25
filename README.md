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

![image](https://github.com/user-attachments/assets/db803d81-5023-4918-8c9f-369ee010beb1)
![image](https://github.com/user-attachments/assets/ee0b3e1e-5583-49dc-8974-65c160993f0c)

---

## GitOps Deployment

- Integrated ArgoCD to implement GitOps workflows  
- Enabled declarative continuous deployment of Helm charts from GitHub repositories  

---

## CI/CD Pipelines

- Created automated Jenkins pipelines to build, test, and deploy applications  
- Included stages for static code analysis, report publishing, and dynamic application security testing (DAST) with OWASP ZAP
![image](https://github.com/user-attachments/assets/914a6278-ddfa-431e-887a-2869cc548d7d)
![image](https://github.com/user-attachments/assets/a178cbf1-166e-4306-9cd0-8741ba7a932c)

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

![image](https://github.com/user-attachments/assets/ff405316-8d50-492a-a9d2-7d3291408985)
![image](https://github.com/user-attachments/assets/b3a6c139-9851-4bd5-ab2f-cd00dc93e410)
![image](https://github.com/user-attachments/assets/01b591be-2e29-4c67-986f-41561702480e)


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
