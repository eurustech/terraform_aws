data "template_file" "init" {
  template = "${file("${path.module}/UserData.sh")}"
  vars = {
    DBUsername = "${var.rds-Username}"
    DBPassword = "${var.rds-Password}"
    DBName = "${var.rds-DBName}"
    DBEndpoint = "${element(split(":", var.rds-Endpoint), 0)}"
    DBPort = "${element(split(":", var.rds-Endpoint), 1)}"
  }
}

resource "aws_launch_configuration" "raza_Launch_Configuration" {
    name = "razaLinuxLaunchConfiguration"
    image_id      = "${var.instance-AMI}"
    instance_type = "t2.micro"
    key_name = "${var.instance-KeyName}"
    security_groups = ["${var.instance-web-sg-id}"]
    root_block_device = {
        delete_on_termination = "true"        
        volume_size = "8"
    }
    user_data = "${data.template_file.init.rendered}"
}
resource "aws_lb" "raza_ELB" {
    name = "raza-lb-web"
    internal           = "false"
    load_balancer_type = "application"
    security_groups    = ["${var.instance-elb-sg-id}"]
    subnets            =  ["${var.vpc-PublicSubnet-Id-01}", "${var.vpc-PublicSubnet-Id-02}"]    
    tags = {
        Name = "raza_Web_ELB"
        Developer = "raza"
    }
}
resource "aws_alb_target_group" "raza_TargetGroup" {
    name     = "raza-lb-tg"
    target_type = "instance"
    port     = "3000"
    protocol = "HTTP"
    vpc_id   = "${var.vpc-id}"
    health_check = {
        interval = "10"
        path = "/api/user"
        port = "3000"
        protocol = "HTTP"
        timeout = "5"
        healthy_threshold = "2"
        unhealthy_threshold = "3"
        matcher = "200"
    }
    tags = {
        Name = "raza_Web_TG"
        Developer = "raza"
    }
}
resource "aws_alb_listener" "raza_ELB_Listener" {
    load_balancer_arn = "${aws_lb.raza_ELB.arn}"
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.raza_TargetGroup.id}"
    }
}
resource "aws_autoscaling_group" "raza_ASG" {
    name                 = "razaAutoscalingGroup"
    launch_configuration = "${aws_launch_configuration.raza_Launch_Configuration.name}"
    min_size             = 2
    max_size             = 3
    vpc_zone_identifier = ["${var.vpc-PublicSubnet-Id-01}", "${var.vpc-PublicSubnet-Id-02}"]
    target_group_arns = ["${aws_alb_target_group.raza_TargetGroup.id}"]   
    tags = [
        {
            key                 = "Name"
            value               = "raza_ASG"
            propagate_at_launch = true
        },
        {
            key                 = "Developer"
            value               = "raza"
            propagate_at_launch = true
        },
    ]
}