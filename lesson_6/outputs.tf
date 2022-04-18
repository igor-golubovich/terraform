


output "webserver_instance_name" {
  value = aws_instance.my_webserver.tags
}
output "webserver_instance_zone" {
  value = aws_instance.my_webserver.availability_zone
}

output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_instance_hardware" {
  value       = aws_instance.my_webserver.instance_type
  description = "complukter"
}

output "webserver_instance_state" {
  value = aws_instance.my_webserver.instance_state
}

output "webserver_instance_private_ip" {
  value = aws_instance.my_webserver.private_ip
}

output "webserver_instance_static_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_instance_public_dns" {
  value = aws_eip.my_static_ip.public_dns
}

output "webserver_secgpoup_id" {
  value = aws_security_group.my_webserver.id
}

output "webserver_secgpoup_description" {
  value = aws_security_group.my_webserver.description
}
