variable "mongo_replicas_count" {
  default     = 3
  description = "number of mongo containers to instantiate"
}

variable "redis_replicas_count" {
  default     = 3
  description = "number of redis containers to instantiate"
}
