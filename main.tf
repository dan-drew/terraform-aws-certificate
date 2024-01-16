terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.east]
    }
  }
}

data "aws_route53_zone" "domain" {
  name = coalesce(var.zone, var.domain)
}

locals {
  domain_name = var.wildcard ? "*.${var.domain}" : var.domain
  alt_names   = var.wildcard ? [var.domain] : []
}

resource "aws_acm_certificate" "cert" {
  domain_name               = local.domain_name
  validation_method         = "DNS"
  subject_alternative_names = local.alt_names
}

resource "aws_acm_certificate" "cert_east" {
  provider                  = aws.east
  domain_name               = local.domain_name
  validation_method         = "DNS"
  subject_alternative_names = local.alt_names
}

locals {
  # Cert will list duplicate records for wildcards
  validation_records = var.validate ? merge([
    for dvo in setunion(aws_acm_certificate.cert.domain_validation_options, aws_acm_certificate.cert_east.domain_validation_options)
    : { "${dvo.resource_record_name}" = dvo }
  ]...) : {}
}

resource "aws_route53_record" "domain_validation" {
  for_each = local.validation_records

  allow_overwrite = true
  name            = each.key
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = data.aws_route53_zone.domain.zone_id
}
