variable "domain" {
  type        = string
  nullable    = false
  description = "Domain to create certificate for"
}

variable "wildcard" {
  type        = bool
  default     = true
  nullable    = false
  description = "Inclue wildcard subdomain (default)"
}

variable "zone" {
  type        = string
  default     = null
  description = "DNS zone to update with validate records (default is domain or zone_id, if provided)"
}

variable "zone_id" {
  type        = string
  default     = null
  description = "Explicit DNS zone ID to update with validate records (exclusive with zone variable)"
}

variable "validate" {
  type        = bool
  default     = true
  description = "Set to false for first run or validation resources will fail with for_each error"
}
