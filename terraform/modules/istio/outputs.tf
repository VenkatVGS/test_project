output "istio_base_status" {
  description = "Status of Istio base installation"
  value       = helm_release.istio_base.status
}

output "istiod_status" {
  description = "Status of Istiod installation"
  value       = helm_release.istiod.status
}

