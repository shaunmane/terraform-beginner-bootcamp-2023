variable "user_uuid" {
  description = "UUID of the user"
  type        = string

  validation {
    condition     = can(regex("^([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})$", var.user_uuid))
    error_message = "user_uuid must be a valid UUID (e.g., xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  }
}

#variable "bucket_name" {
#  description = "The name of the S3 bucket"
#  type = string
#
#  validation {
#    condition = can(regex("^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
#    error_message = "The bucket name must be between 3 and 63 characters long, only contain lowercase letters, numbers, and hyphens, and must not be formatted as an IP address."
#  }
#}

variable "index_html_filepath" {
  description = "Path to the index.html file"
  type = string

  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The file at path ${var.index_html_filepath} does not exist. Please provide a valid file path."
  }
}

variable "error_html_filepath" {
  description = "Path to the error.html file"
  type = string

  validation {
    condition = fileexists(var.error_html_filepath)
    error_message = "The file at path ${var.error_html_filepath} does not exist. Please provide a valid file path."
  }
}

variable "content_version" {
  description = "The content version number. It must be a positive integer starting at 1."
  type        = number

  validation {
    condition     = var.content_version > 0 && var.content_version == floor(var.content_version)
    error_message = "content_version must be a positive integer starting at 1."
  }
}

variable "assets_path" {
  description = "Path to assets folder"
  type        = string
}