output "arn" {
  value       = aws_acm_certificate.cert.arn
  description = "Certificate ARN"
}

output "arn-east" {
  value       = aws_acm_certificate.cert_east.arn
  description = "Certificate ARN for us-east-1"
}
