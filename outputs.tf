output "fqdn" {
  description = "opensearch_fqdn"
  value       = aws_route53_record.opensearch[0].fqdn
}