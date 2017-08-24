# Last Amazon Linux
data "aws_ami" "ephemeral_instance_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }

  filter {
    name   = "owner-id"
    values = ["137112412989"]
  }
}

# Prepare shell script
data "template_file" "shell_script" {
  template = "${var.shell_script}"

  vars {
    DATABASE_ENDPOINT = "${var.endpoint}"
    DATABASE_PORT     = "${var.port}"
    DATABASE_NAME     = "${var.database}"
    DATABASE_USER     = "${var.master_username}"
    DATABASE_PASSWORD = "${var.master_password}"
  }
}

# Prepare MySQL script
data "template_file" "mysql_script" {
  template = "${var.sql_script}"

  vars {
    DATABASE_NAME     = "${var.database}"
  }
}

# Bootstrap script
data "template_file" "user_data" {
  template = "${file("${path.module}/scripts.sh.tpl")}"

  vars {
    DATABASE_ENDPOINT = "${var.endpoint}"
    DATABASE_PORT     = "${var.port}"
    DATABASE_NAME     = "${var.database}"
    DATABASE_USER     = "${var.master_username}"
    DATABASE_PASSWORD = "${var.master_password}"
    MYSQL_SCRIPT      = "${data.template_file.mysql_script.rendered}"
    SHELL_SCRIPT      = "${data.template_file.shell_script.rendered}"
  }
}

resource "aws_instance" "ephemeral_instance" {
  subnet_id              = "${var.subnet_id}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  ami                    = "${data.aws_ami.ephemeral_instance_ami.id}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  user_data              = "${data.template_file.user_data.rendered}"
  tags                   = "${map("Name", format("%s-RDS_BOOSTRAP_EPHEMERAL_INSTANCE", var.name))}"

  # Terminate instance on shutdown
  instance_initiated_shutdown_behavior = "terminate"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "128"
    delete_on_termination = "true"
  }

  volume_tags = "${map("Name", format("%s-RDS_BOOSTRAP_EPHEMERAL_INSTANCE", var.name))}"

}
