output "ephemeral_instance_ami" {
  value = "${data.aws_ami.ephemeral_instance_ami.id}"
}
