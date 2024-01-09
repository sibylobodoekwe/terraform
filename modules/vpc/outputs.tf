output "vpc_id" {
  value = aws_vpc.altcloud_vpc.id
}

output "altcloud_public_subnet_id" {
  value = aws_subnet.altcloud_public_subnet.id
}

output "altcloud_private_subnet_id" {
  value = aws_subnet.altcloud_private_subnet.id
}
