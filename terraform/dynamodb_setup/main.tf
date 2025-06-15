provider "aws" {
  region = "eu-north-1"  # or your region
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "solarsys-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
