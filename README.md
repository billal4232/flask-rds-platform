
```markdown
# Flask RDS Platform

A production-style Flask web application deployed on AWS, featuring a private RDS PostgreSQL database, Application Load Balancer with HTTPS, SSM Parameter Store for secrets management, and fully automated infrastructure via Terraform.

**Live URL:** https://app.limonlab.online

---

## Architecture

![Architecture Diagram](docs/architecture.png)

### Traffic Flow
```
User → Route53 → ALB (HTTPS/443) → EC2/Flask (HTTP/80) → RDS PostgreSQL (5432)
```

### Infrastructure Overview
- **VPC** — Custom VPC with public and private subnets across 2 AZs
- **ALB** — Application Load Balancer in public subnets, handles SSL termination
- **EC2** — Flask app running in private subnet, no public IP
- **RDS** — PostgreSQL 16 in private subnet, only accessible from EC2
- **NAT Gateway** — Allows EC2 outbound internet access from private subnet
- **ACM** — SSL certificate for custom domain
- **Route53** — DNS routing to ALB
- **SSM Parameter Store** — Stores database credentials securely
- **S3** — Stores application code, pulled by EC2 at boot
- **IAM** — EC2 role with SSM read and S3 read permissions

---

## Tech Stack

| Layer | Technology |
|---|---|
| Application | Python 3, Flask |
| Database | PostgreSQL 16 (AWS RDS) |
| Infrastructure | Terraform |
| Compute | AWS EC2 (Amazon Linux 2023) |
| Networking | VPC, ALB, Route53, ACM |
| Secrets | SSM Parameter Store |
| Deployment | S3 + user_data bootstrapping |

---

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | /health | Health check — returns 200 |
| GET | /users | Fetch all users from database |
| POST | /users | Add a new user to database |

### Example POST request
```json
{
    "name": "John Smith",
    "email": "john@gmail.com"
}
```

### Example GET /users response
```json
[
    [1, "John Smith", "john@gmail.com", "2026-05-28T16:58:00"]
]
```

---

## Project Structure

```
flask-rds-platform/
├── app/
│   └── app.py              # Flask application
├── terraform/
│   ├── vpc.tf              # VPC, subnets, NAT Gateway
│   ├── security_groups.tf  # ALB, EC2, RDS security groups
│   ├── ec2.tf              # EC2 instance
│   ├── rds.tf              # RDS PostgreSQL instance
│   ├── alb.tf              # ALB, listeners, target group
│   ├── iam.tf              # IAM role and policies
│   ├── ssm.tf              # SSM Parameter Store
│   ├── acm.tf              # SSL certificate
│   ├── route53.tf          # DNS records
│   ├── s3.tf               # S3 bucket for app code
│   ├── providers.tf        # AWS provider configuration
│   ├── variables.tf        # Variable definitions
│   └── outputs.tf          # Output values
├── scripts/                # boto3 automation scripts (coming soon)
├── .gitignore
└── README.md
```

---

## Deployment

### Prerequisites
- Terraform installed
- AWS CLI configured with profile `limonlab`
- S3 bucket for remote state: `limonlab-terraform-state`

### Deploy
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Destroy
```bash
terraform destroy
```

> ⚠️ NAT Gateway costs ~$32/month. Destroy when not in use.

---

## Security Notes
- EC2 has no public IP — only reachable via ALB or SSM Session Manager
- RDS has no public access — only reachable from EC2 security group
- Database credentials stored in SSM Parameter Store — never hardcoded
- HTTPS enforced — HTTP redirects to HTTPS via ALB listener rule
- API endpoints are currently unauthenticated — authentication will be added in V2

---

## Roadmap

- **V1** ✅ Flask + RDS PostgreSQL, ALB, HTTPS, SSM, Terraform
- **V2** 🔲 Add AWS Lambda, API authentication
- **V3** 🔲 Add CI/CD pipeline — automated deployments on code push
```

