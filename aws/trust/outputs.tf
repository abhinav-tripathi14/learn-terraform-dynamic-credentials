output "openid_claims" {
  description = "OpenID Claims for trust relationship"
  value       = one(jsondecode(aws_iam_role.tfc_role.assume_role_policy).Statement).Condition
}

output "role_arn" {
  description = "ARN for trust relationship role"
  value       = aws_iam_role.tfc_role.arn
}

output "aws_iam_openid_connect_provider"{
  value = aws_iam_openid_connect_provider.tfc_provider.arn
}

output "client_id_list"{
  value = aws_iam_openid_connect_provider.tfc_provider.client_id_list
}
