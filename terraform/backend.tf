terraform {
  backend "s3" {
    bucket         = "solar-sys-state-eldi-2025"   
    key            = "terraform.tfstate"             
    region         = "eu-north-1"
    dynamodb_table = "solarsys-lock-table"          
    encrypt        = true
  }
}
