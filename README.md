# 🚀 Terraform Azure Load Balancer + VMSS Project

## 📌 Overview

This project demonstrates how to build a **scalable Azure infrastructure** using Terraform with modular design.

It includes:

* Virtual Network & Subnet
* Network Security Group (NSG)
* Azure Load Balancer
* Virtual Machine Scale Set (VMSS)

---

## 🏗️ Architecture

Users → Load Balancer → VM Scale Set (Auto Scaling)

---

## 📂 Project Structure

```
Modules/
  ├── network
  ├── nsg
  ├── lb
  └── vmss
```

---

## ⚙️ Features

✅ Modular Terraform design
✅ Load balancing (Layer 4)
✅ Backend pool integration
✅ Health probe configuration
✅ Auto-scalable infrastructure (VMSS)

---

## 🚀 Deployment Steps

```bash
terraform init
terraform plan
terraform apply
```

---

## 🌐 Access Application

After deployment:

```
http://<LoadBalancer-Public-IP>
```

---

## 🔄 Migration Highlight

This project demonstrates migration from:

* ❌ Static VMs (count)
* ✅ VM Scale Set (auto scaling)

---

## 📈 Future Enhancements

* Auto scaling rules (CPU-based)
* HTTPS (SSL)
* Application Gateway
* CI/CD pipeline

---

## 👨‍💻 Author

Sandeep Narwade

---

## ⭐ If you like this project

Give it a ⭐ on GitHub!
