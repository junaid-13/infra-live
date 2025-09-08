
variable "emails" {
  description = "Email addresses to notify on budget alerts"
  type        = list(string)
}

variable "amounts" {
  description = "Monthly budget caps per env"
  type = object({
    dev   = number
    stage = number
    prod  = number
  })
}
