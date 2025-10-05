# AWS DevOps Infrastructure Architecture

## System Architecture Diagram

```mermaid
flowchart TB
    %% External Users
    User["👩‍💻 User / Developer"]

    %% CI/CD Pipeline
    subgraph CICD["🚀 CI/CD Pipeline - GitHub Actions"]
        GA["💡 GitHub Actions"]
        GS["🧩 Gemini Security Scan"]
        BT["⚙️ Build & Test"]
        DP["📦 Deploy to EKS"]
    end

    %% Networking & Compute
    subgraph VPC["🌐 VPC (10.0.0.0/16)"]
        subgraph PublicSubnet["🌍 Public Subnets (2 AZs)"]
            IGW["🛰 Internet Gateway"]
            NAT["🌉 NAT Gateway"]
            ALB["🧭 Application Load Balancer"]
        end

        subgraph PrivateSubnet["🔒 Private Subnets (2 AZs)"]
            subgraph EKS["☸️ EKS Cluster (idurar-erp-cluster)"]
                subgraph NodeGroups["🧱 Node Groups"]
                    NG1["🖥 System Nodes"]
                    NG2["📦 Application Nodes"]
                end

                subgraph Services["🧩 Kubernetes Services"]
                    HW["🌈 hello-world<br/>Microservice"]
                    FB["🪶 FluentBit<br/>Logging Agent"]
                    IS["🌐 Istio<br/>Service Mesh"]
                end
            end

            %% Data Layer
            subgraph DataLayer["💾 Data Layer"]
                RDS["🗄 RDS PostgreSQL<br/>(Multi-AZ)"]
                Redis["⚡ ElastiCache Redis<br/>Cluster"]
            end
        end
    end

    %% AWS Managed Services
    subgraph AWSServices["🧰 AWS Managed Services"]
        ECR["🐳 ECR - Container Registry"]
        S3["🗂 S3 - Static Assets &<br/>Terraform State"]
        CW["📊 CloudWatch - Monitoring<br/>& Logging"]
        SSM["🔐 SSM Parameter Store<br/>Secrets Management"]
    end

    %% Security & Compliance
    subgraph Security["🛡 Security & Compliance"]
        GD["🧠 GuardDuty - Threat Detection"]
        Config["📋 AWS Config - Compliance"]
        KMS["🔑 KMS - Encryption Keys"]
        IAM["👥 IAM - Least Privilege Access"]
    end

    %% Connections
    User --> ALB
    ALB --> HW

    GA --> GS
    GS --> BT
    BT --> ECR
    BT --> DP
    DP --> EKS

    HW --> RDS
    HW --> Redis
    HW --> SSM

    FB --> CW
    HW --> CW
    EKS --> CW

    PublicSubnet --> IGW
    PrivateSubnet --> NAT
    NAT --> IGW

    GD -.-> EKS
    GD -.-> RDS
    GD -.-> S3
    Config -.-> RDS
    Config -.-> S3

    KMS -.-> RDS
    KMS -.-> S3
    KMS -.-> SSM
    KMS -.-> EBS

    %% Class Styling - Dark Theme
    classDef user fill:#ffcc00,stroke:#ffd700,color:#000,stroke-width:2px;
    classDef cicd fill:#a29bfe,stroke:#6c5ce7,color:#fff,stroke-width:2px;
    classDef aws fill:#f1c40f,stroke:#d4ac0d,color:#000,stroke-width:2px;
    classDef k8s fill:#3498db,stroke:#1f618d,color:#fff,stroke-width:2px;
    classDef data fill:#2ecc71,stroke:#1e8449,color:#fff,stroke-width:2px;
    classDef security fill:#e74c3c,stroke:#922b21,color:#fff,stroke-width:2px;
    classDef bg fill:#0d1117,stroke:#0d1117,color:#fff;

    class CICD,GA,GS,BT,DP cicd
    class VPC,IGW,NAT,ALB,ECR,S3,CW,SSM aws
    class EKS,NodeGroups,Services,HW,FB,IS k8s
    class RDS,Redis data
    class GD,Config,KMS,IAM security
    class User user
