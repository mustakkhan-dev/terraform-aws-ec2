# 🚀 Automated AWS EC2 Deployment with Terraform

An Infrastructure-as-Code (IaC) project that automatically provisions an **Ubuntu 24.04 LTS EC2 instance** inside the default VPC on AWS using **Terraform**.

---

## 📌 Features

- **Automated VPC & Subnet Lookup:** Automatically queries your AWS account's default VPC and available subnets without hardcoding network IDs.
- **Dynamic AMI Discovery:** Automatically fetches the most recent official Canonical **Ubuntu 24.04 LTS (Noble Numbat)** AMI for the target region.
- **Security Group Provisioning:** Configures a dedicated Security Group allowing inbound SSH (port 22) and open outbound internet connectivity.
- **Customizable Variables:** Easily configure instance type, tag names, and AMI parameters.
- **Instant Outputs:** Emits the newly deployed EC2 instance ID, private IP, and public IP immediately after provisioning.

---

## 📂 Project Structure

```text
terraform-ec2/
├── .gitignore          # Prevents pushing sensitive state files and caches
├── provider.tf         # Terraform and AWS provider requirements
├── variable.tf         # Configurable input variables
├── main.tf             # Core infrastructure definitions (VPC data, AMI, SG, EC2)
├── output.tf           # Output values (Instance ID, Public/Private IPs)
└── README.md           # Project documentation and guide
```

---

## ⚙️ Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **[Terraform CLI](https://developer.hashicorp.com/terraform/downloads)** (`>= 1.5.0`)
2. **[AWS CLI](https://aws.amazon.com/cli/)** installed and authenticated with appropriate IAM permissions (EC2 and VPC access).
   ```bash
   aws configure
   ```

---

## 🔧 Variables Reference

| Variable Name | Description | Type | Default Value |
| :--- | :--- | :--- | :--- |
| `instance_type` | EC2 instance size/type | `string` | `"t3.micro"` |
| `instance_name` | Name tag assigned to EC2 instance | `string` | `"terraform-ec2"` |

*(Note: The AMI is resolved automatically and dynamically via official Canonical data sources in `main.tf`, eliminating any hardcoded IDs).*

---

## 📤 Outputs

| Output Name | Description |
| :--- | :--- |
| `instance_id` | The unique AWS ID of the created EC2 instance |
| `private_ip` | Private IPv4 address within the VPC subnet |
| `public_ip` | Public IPv4 address for internet/SSH access |

---

## 🚀 Quickstart Guide

### 1. Clone the Repository
```bash
git clone https://github.com/<your-username>/terraform-ec2.git
cd terraform-ec2
```

### 2. Initialize Terraform
Initializes the working directory, downloads the AWS provider plugins, and prepares the backend:
```bash
terraform init
```

### 3. Review the Execution Plan
Preview the infrastructure changes that will be created:
```bash
terraform plan
```

### 4. Apply Infrastructure
Deploy the EC2 instance and Security Group:
```bash
terraform apply
```
*Type `yes` when prompted to confirm the deployment.*

### 5. Access Your Instance
Once `apply` finishes, Terraform prints the `public_ip`. You can connect via SSH (ensure you attach an SSH key pair or configure AWS Systems Manager Session Manager if required):
```bash
ssh -i /path/to/your-key.pem ubuntu@<PUBLIC_IP>
```

### 6. Clean Up (Destroy)
To avoid ongoing AWS cloud charges when you are done testing, tear down all created resources:
```bash
terraform destroy
```
*Type `yes` when prompted to confirm removal.*

---

## 🔒 Security Best Practices

> [!WARNING]
> **SSH Port 22:** The security group currently allows SSH access from `0.0.0.0/0` (anywhere). For production environments, it is recommended to restrict `cidr_blocks` in `main.tf` to your own public IP address (e.g. `["YOUR_IP/32"]`).

> [!IMPORTANT]
> **State Files:** Never commit `terraform.tfstate` or `terraform.tfstate.backup` to version control. They may contain sensitive metadata and IP addresses. The included `.gitignore` keeps these files excluded locally.

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information (if applicable).
