
variable "rg_m" {
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    owner      = string
    tags       = optional(map(string), {})
  }))
}