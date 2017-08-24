RDS bootstrap module
====================

A terraform module to provide a simple AWS RDS database bootstrap
(typically running SQL code to create users, DB schema, ...).

What it does:
- creates a micro EC2 ephemeral instance when RDS is provisioned
- via this instance, connects to the cluster and run boostrap SQL scripts
- then kill this ephemeral instance.

It allows you to easily embed automated DB provisioning in your infrastructure building process.


Module Input Variables
----------------------

- `name` - the base name used on all module resources as an identifier (default `RDS_BOOSTRAP_EPHEMERAL`)
- `subnet_id` - the subnet in which the ephemeral instance will be launched
- `security_group_ids` - a list of security groups the ephemeral instance will belong to (use it to allow access to the RDS cluster), default `[]`
- `iam_instance_profile` - instance profile name that will be used by the bootstrap instance
- `endpoint` - your RDS connection endpoint
- `port` - your RDS connection port
- `master_username` - your RDS cluster master user name
- `master_password` - your RDS cluster master user password
- `database` - your database name
- `shell_script` - (optional) a shell script template that will be run from the ephemeral instance (details below)
- `mysql_script` - (optional) a SQL script that will be run from the ephemeral instance against a MySQL/Aurora RDS DB
- `instance_type` - (optional, default `t2.micro`) ephemeral instance type

Usage
-----

```hcl
module "rds_boostrap" {
  source = "github.com/fvinas/tf_rds_boostrap"

  name = "RDS_BOOSTRAP"

  subnet_id = "aws_subnet.private.id"
  security_group_ids = ["aws_security_group.rds_access.id"]

  endpoint = "${aws_rds_cluster.aurora_cluster.endpoint}"
  port = "${aws_rds_cluster.aurora_cluster.port}"

  database = "${aws_rds_cluster.aurora_cluster.database_name}"
  master_username = "${aws_rds_cluster.aurora_cluster.master_username}"
  master_password = "${var.rds_master_password}"

  mysql_script = <<-EOF
              CREATE TABLE my_table (
                ...
              );
              GRANT SELECT, INSERT, UPDATE ON ${DATABASE_NAME}.my_table TO 'new_user'@'%' IDENTIFIED BY 'password';
              EOF
}
```

For Terraform version older than 0.7.0 use `ref=v1.0.0`:
`source = "github.com/fvinas/tf_rds_boostrap?ref=v1.0.0"`

Outputs
=======

None

TODO
====

- out-of-the-box support for DB other than MySQL/Aurora
- support for encrypted RDS

Authors
=======

Originally created and maintained by [Fabien Vinas](https://github.com/fvinas)

License
=======

Apache 2 Licensed. See LICENSE for full details.