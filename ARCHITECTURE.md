# AWS DevOps Infrastructure Architecture

## System Architecture Diagram

```mermaid
flowchart TB
    %% External Users
    User[User / Developer]
    
    %% CI/CD Pipeline
    subgraph CICD[CI/CD Pipeline - GitHub Actions]
        GA[GitHub Actions]
        GS[Gemini Security Scan]
        BT[Build & Test]
        DP[Deploy to EKS]
    end

    %% Networking
    subgraph VPC[VPC - 10.0.0.0/16]
        subgraph PublicSubnet[Public Subnets - 2 AZs]
            IGW[Internet Gateway]
            NAT[NAT Gateway]
            ALB[Application Load Balancer]
        end
        
        subgraph PrivateSubnet[Private Subnets - 2 AZs]
            %% EKS Cluster
            subgraph EKS[EKS Cluster - idurar-erp-cluster]
                subgraph NodeGroups[Node Groups]
                    NG1[System Nodes]
                    NG2[Application Nodes]
                end
                
                subgraph Services[Kubernetes Services]
                    HW[hello-world<br/>Microservice]
                    FB[FluentBit<br/>Logging]
                    IS[Istio<br/>Service Mesh]
                end
            end
            
            %% Data Layer
            subgraph DataLayer[Data Storage]
                RDS[(RDS PostgreSQL<br/>Multi-AZ)]
                Redis[(ElastiCache Redis<br/>Cluster)]
            end
        end
    end

    %% AWS Services
    subgraph AWSServices[AWS Managed Services]
        ECR[ECR - Container Registry]
        S3[S3 - Static Assets &<br/>Terraform State]
        CW[CloudWatch - Monitoring<br/>& Logging]
        SSM[SSM Parameter Store<br/>Secrets Management]
    end

    %% Security & Compliance
    subgraph Security[Security & Compliance]
        GD[GuardDuty - Threat Detection]
        Config[AWS Config - Compliance]
        KMS[KMS - Encryption Keys]
        IAM[IAM - Least Privilege]
    end

    %% Connections
    %% User Access
    User --> ALB
    ALB --> HW
    
    %% CI/CD Flow
    GA --> GS
    GS --> BT
    BT --> ECR
    BT --> DP
    DP --> EKS
    
    %% Application Dependencies
    HW --> RDS
    HW --> Redis
    HW --> SSM
    
    %% Logging & Monitoring
    FB --> CW
    HW --> CW
    EKS --> CW
    
    %% Networking
    PublicSubnet --> IGW
    PrivateSubnet --> NAT
    NAT --> IGW
    
    %% Security Monitoring
    GD -.-> EKS
    GD -.-> RDS
    GD -.-> S3
    Config -.-> RDS
    Config -.-> S3
    
    %% Encryption
    KMS -.-> RDS
    KMS -.-> S3
    KMS -.-> SSM
    KMS -.-> EBS
    
    %% Styling
    classDef aws fill:#ff9900,color:#000
    classDef k8s fill:#326ce5,color:#fff
    classDef data fill:#5cb85c,color:#fff
    classDef security fill:#d9534f,color:#fff
    classDef cicd fill:#6f42c1,color:#fff
    
    class VPC,IGW,NAT,ALB,ECR,S3,CW,SSM,GD,Config,KMS,IAM,RDS,Redis aws
    class EKS,NodeGroups,Services,HW,FB,IS k8s
    class RDS,Redis data
    class GD,Config,KMS,IAM security
    class CICD,GA,GS,BT,DP cicd
