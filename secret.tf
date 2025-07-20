# Generate a strong random password
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "-!$&"
}

# Create a Secrets Manager secret to store the DB password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-password-v2"
}

# Store the random password in Secrets Manager
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_password.result
}




# resource "random_password" "db_password" {
#   length           = 20
#   special          = true
#   override_special = "-!$&"
# }

# # NOTE: Since we aren't specifying a KMS key this will default to using
# # `aws/secretsmanager`/
# resource "aws_secretsmanager_secret" "db_secret" {
#   name        = "prod-db-password"
# }

# resource "aws_secretsmanager_secret_version" "secret_version" {
#   secret_id     = aws_secretsmanager_secret.db_secret.id
#   secret_string = random_password.db_password.result
# }