##########################################################
# DATA SOURCES
##########################################################
data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "eks_oidc" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

##########################################################
# IAM POLICY
##########################################################
resource "aws_iam_policy" "fluent_bit_cloudwatch" {
  name        = "FluentBitCloudWatchPolicy"
  description = "Policy for Fluent Bit to push logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

##########################################################
# IAM ROLE FOR IRSA
##########################################################
resource "aws_iam_role" "fluent_bit_irsa" {
  name = "FluentBitIRSA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:default:fluent-bit"
        }
      }
    }]
  })
}

##########################################################
# ATTACH POLICY TO ROLE
##########################################################
resource "aws_iam_role_policy_attachment" "fluent_bit_attach" {
  role       = aws_iam_role.fluent_bit_irsa.name
  policy_arn = aws_iam_policy.fluent_bit_cloudwatch.arn
}

##########################################################
# SERVICE ACCOUNT
##########################################################
resource "kubernetes_service_account" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluent_bit_irsa.arn
    }
  }
}

##########################################################
# CONFIGMAP
##########################################################
resource "kubernetes_config_map" "fluent_bit" {
  metadata {
    name      = "fluent-bit-config"
    namespace = "default"
  }

  data = {
    "fluent-bit.conf" = <<-EOT
[SERVICE]
    Flush        1
    Log_Level    info
    Daemon       off
    Parsers_File parsers.conf

[INPUT]
    Name              tail
    Path              /var/log/containers/*hello-world*.log
    Parser            docker
    Tag               kube.*
    Refresh_Interval  5
    Mem_Buf_Limit     5MB
    Skip_Long_Lines   On

[FILTER]
    Name                kubernetes
    Match               kube.*
    Kube_URL            https://kubernetes.default.svc.cluster.local:443
    Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
    Kube_Tag_Prefix     kube.var.log.containers.
    Merge_Log           On
    Merge_Log_Key       log_processed
    K8S-Logging.Parser  On
    K8S-Logging.Exclude Off

[OUTPUT]
    Name cloudwatch_logs
    Match *
    region ${var.region}
    log_group_name /eks/${var.eks_cluster_name}/hello-world
    log_stream_prefix from-fluent-bit-
    auto_create_group true
EOT

    "parsers.conf" = <<-EOT
[PARSER]
    Name docker
    Format json
    Time_Key time
    Time_Format %Y-%m-%dT%H:%M:%S.%LZ
EOT
  }
}

##########################################################
# DAEMONSET
##########################################################
resource "kubernetes_daemonset" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = "default"
    labels = {
      k8s-app = "fluent-bit-logging"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "fluent-bit-logging"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "fluent-bit-logging"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.fluent_bit.metadata[0].name

        container {
          name  = "fluent-bit"
          image = "fluent/fluent-bit:2.2.0"

          env {
            name  = "AWS_REGION"
            value = var.region
          }

          env {
            name  = "EKS_CLUSTER_NAME"
            value = var.eks_cluster_name
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
            read_only  = true
          }

          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }

          volume_mount {
            name       = "fluent-bit-config"
            mount_path = "/fluent-bit/etc/"
          }
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "fluent-bit-config"
          config_map {
            name = kubernetes_config_map.fluent_bit.metadata[0].name
          }
        }
      }
    }
  }
}

##########################################################
# CLUSTER ROLE & BINDING
##########################################################
resource "kubernetes_cluster_role" "fluent_bit" {
  metadata {
    name = "fluent-bit"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "fluent_bit" {
  metadata {
    name = "fluent-bit"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.fluent_bit.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.fluent_bit.metadata[0].name
    namespace = "default"
  }
}

