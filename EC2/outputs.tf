output "raza_elb_dns" {
  value = "${aws_lb.raza_ELB.dns_name}"
}