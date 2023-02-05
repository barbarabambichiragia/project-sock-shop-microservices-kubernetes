output "sskeu1_Master01_Node" {
  value       = aws_instance.sskeu1_Master01_Node.public_ip
  description = "Master01 Node ip"
}
output "sskeu1_Master02_Node" {
  value       = aws_instance.sskeu1_Master02_Node.public_ip
  description = "Master02 Node ip"
}
output "sskeu1_Worker01_Node" {
  value       = aws_instance.sskeu1_Worker01_Node.public_ip
  description = "Worker01 Node ip"
}
output "sskeu1_Worker02_Node" {
  value       = aws_instance.sskeu1_Worker02_Node.public_ip
  description = "Worker02 Node ip"
}

output "sskeu1_ansible_node" {
  value       = aws_instance.sskeu1_ansible_node.public_ip
  description = "ansible Node ip"
}