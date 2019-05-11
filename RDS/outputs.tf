output "rds_endpoint" {
  value = "${aws_db_instance.raza_MySQL_DB_Instance.endpoint}"
}
output "rds_dbname" {
  value = "${aws_db_instance.raza_MySQL_DB_Instance.name}"
}