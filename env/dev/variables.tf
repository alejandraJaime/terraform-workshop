# Id del proyecto en GCP
variable "gcp_project" {
  type = string
  default = "mm-spla-tse-internal-hub"
}

# Region en que vamos a desplegar el bucket de GCS
variable "gcp_region" {
  type = string
  default = "us-east1"
}

# Ruta del archivo de credenciales 
variable "sa_credentials_file_path" {
  type = string
  default = "../../credentials/terraform-workshop-sa.json"
}

# Agrega un prefijo unico para identificar tu infra 
variable "user-prefix" {
  type = string
  default = "ale-jaime-sa"
}