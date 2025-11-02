# Zero Trust Network Setup with Twingate and Terraform

A production-ready infrastructure-as-code solution for deploying a Zero Trust Network using Twingate VPN with Docker-based media services. This setup follows Terraform best practices and provides secure remote access to your self-hosted applications.

## 🎯 Features

- **Zero Trust Security**: Twingate-based VPN with granular access controls
- **Automated Deployment**: Complete infrastructure provisioned via Terraform
- **Media Stack**: Pre-configured Sonarr, Radarr, Overseerr, Prowlarr, and FlareSolverr
- **Network Isolation**: Dedicated Docker network for enhanced security
- **Production Ready**: Includes state management, validation, and lifecycle rules
- **Comprehensive Outputs**: Easy access to service endpoints and resource information

## 📋 Prerequisites

### Required Software

- **Terraform** >= 1.5.0 - [Download](https://www.terraform.io/downloads.html)
- **Docker** >= 20.10 - [Download](https://docs.docker.com/get-docker/)
- **Twingate Account** - [Sign up](https://www.twingate.com/)

### Twingate Prerequisites

1. Active Twingate account with admin access
2. API token (Settings > API > Generate Token)
3. Group ID for access control (Teams > [Your Group] > Copy Group ID)

## 🚀 Quick Start

### 1. Clone and Configure

```bash
# Clone the repository (if not already done)
git clone <your-repo-url>
cd zero-trust-network-setup/terraform

# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars
```

### 2. Edit Configuration

Open `terraform.tfvars` and configure your settings:

```hcl
account_name = "your-twingate-account"
api_key      = "your-api-key-here"
group_id     = "your-group-id"
timezone     = "Europe/Paris"  # Your timezone
volume_path  = "/path/to/volumes"  # Optional
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan and Apply

```bash
# Review the changes
terraform plan

# Apply the configuration
terraform apply
```

### 5. Access Your Services

After deployment, access your services through Twingate:

- **Overseerr**: `media.mania` or `nas-media-prod-overseerr`
- **Sonarr**: `nas-media-prod-sonarr`
- **Radarr**: `nas-media-prod-radarr`
- **Prowlarr**: `nas-media-prod-prowlarr`

## 📁 Project Structure

```
.
├── README.md
├── config.json
└── terraform/
    ├── backend.tf           # State management configuration
    ├── docker.tf            # Docker resources (images, containers, network)
    ├── locals.tf            # Local values and computed variables
    ├── main.tf              # Provider configuration
    ├── outputs.tf           # Output values
    ├── twingate.tf          # Twingate resources (network, connector, resources)
    ├── variables.tf         # Input variables with validation
    └── terraform.tfvars.example  # Example configuration
```

## ⚙️ Configuration Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `account_name` | Twingate account name | `mycompany` |
| `api_key` | Twingate API token (sensitive) | `tk_***` |
| `group_id` | Twingate group ID | `R3JvdXA...` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Project name for resource naming | `nas-media` |
| `environment` | Environment (dev/staging/prod) | `prod` |
| `timezone` | Container timezone | `UTC` |
| `volume_path` | Base path for Docker volumes | `""` (current directory) |
| `twingate_connector_log_level` | Connector log verbosity (0-7) | `3` |

## 🏗️ Infrastructure Components

### Twingate Resources

- **Remote Network**: Isolated network for your resources
- **Connector**: Bridge between Twingate and your network
- **Resources**: Individual service access points with security policies

### Docker Resources

- **Custom Network**: `172.20.0.0/16` bridge network
- **Twingate Connector**: VPN gateway container
- **Media Services**:
  - Overseerr (Port 5055) - Media request management
  - Sonarr (Port 8989) - TV show management
  - Radarr (Port 7878) - Movie management
  - Prowlarr (Port 9696) - Indexer management
  - FlareSolverr (Port 8191) - Cloudflare bypass

## 🔒 Security Best Practices

### Implemented Security Features

1. **Zero Trust Access**: All services behind Twingate VPN
2. **Network Isolation**: Containers on dedicated bridge network
3. **Least Privilege**: RESTRICTED TCP policies, UDP denied
4. **State Encryption**: Support for encrypted remote state
5. **Sensitive Variables**: API keys marked as sensitive
6. **Input Validation**: All variables validated before use

### Recommendations

- Use remote state backend (Terraform Cloud, S3, etc.)
- Rotate Twingate API tokens regularly
- Enable MFA on Twingate accounts
- Review access logs periodically
- Keep Docker images updated

## 📊 Terraform Best Practices Applied

### Resource Management

- ✅ Version constraints on Terraform and providers
- ✅ Lifecycle rules (`prevent_destroy`, `create_before_destroy`)
- ✅ Proper dependency management with `depends_on`
- ✅ Ignore changes for dynamic attributes

### Code Organization

- ✅ Logical file separation by resource type
- ✅ Local values for computed/reusable values
- ✅ Comprehensive outputs for service discovery
- ✅ Descriptive comments and documentation

### Operational Excellence

- ✅ Input validation with helpful error messages
- ✅ Consistent naming conventions
- ✅ Resource tagging for management
- ✅ Example configuration file

## 🔧 Common Operations

### Viewing Outputs

```bash
# View all outputs
terraform output

# View specific output
terraform output service_endpoints

# View in JSON format
terraform output -json
```

### Updating Services

```bash
# Update a specific resource
terraform apply -target=docker_container.overseerr

# Force recreation
terraform taint docker_container.overseerr
terraform apply
```

### Destroying Resources

```bash
# Destroy all resources (warning: data loss!)
terraform destroy

# Destroy specific resource
terraform destroy -target=docker_container.overseerr
```

## 🐛 Troubleshooting

### Twingate Connector Not Connecting

```bash
# Check connector logs
docker logs nas-media-prod-twingate-connector

# Verify tokens are valid
terraform output -json | grep -A 2 twingate_connector
```

### Container Network Issues

```bash
# Verify network exists
docker network ls | grep nas-media

# Inspect network
docker network inspect nas-media-prod-network
```

### Volume Permission Issues

```bash
# Fix permissions (Linux)
sudo chown -R 1000:1000 /path/to/volumes

# Or use your user
sudo chown -R $USER:$USER /path/to/volumes
```

## 🔄 State Management

By default, Terraform stores state locally. For production use, configure a remote backend in `backend.tf`:

### Terraform Cloud (Recommended)

```hcl
terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "zero-trust-network"
    }
  }
}
```

### AWS S3

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state"
    key            = "zero-trust-network/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

## 📚 Additional Resources

- [Twingate Documentation](https://docs.twingate.com/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Zero Trust Architecture](https://www.nist.gov/publications/zero-trust-architecture)

## 📝 License

[Your License Here]

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support

For issues and questions:
- Create an issue in this repository
- Contact: [Your Contact Information]

---

**⚠️ Important**: Never commit `terraform.tfvars` or `terraform.tfstate` to version control. These files contain sensitive information.