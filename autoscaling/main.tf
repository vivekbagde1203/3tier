resource "aws_launch_configuration" "my-auto-dev" {
    name          = "my-auto-dev"
    image_id      = "ami-0851b76e8b1bce90b"
    instance_type = "t2.micro"
    user_data = <<-EOF
                #!/bin/bash
                yum -y install httpd
                echo "terraform web" >> /var/www/html/index.html
                systemctl start httpd
                systemctl enable httpd
                EOF
    lifecycle {
        create_before_destroy = true
    }
}
resource "aws_autoscaling_group" "myautoscale-dev" {
    name                      = "myautoscale-dev"
    max_size                  = 2
    min_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "ELB"
    #desired_capacity          = 3
    #force_delete              = true
    launch_configuration      = aws_launch_configuration.my-auto-dev.name
    #vpc_zone_identifier      = [aws_subnet.example1.id, aws_subnet.example2.id]
    vpc_zone_identifier       = ["${var.subnet1}","${var.subnet2}"]
    target_group_arns         = ["${var.target_group_arn}"]
    tag {
        key                 = "Name"
        value               = "my-dev-autoscalegroup"
        propagate_at_launch = true
    }
}
resource "aws_security_group" "my-asg-sg" {
    name   = "my-asg-sg"
    vpc_id = var.dev-vpc
}

resource "aws_security_group_rule" "inbound_ssh" {
    from_port         = 22
    protocol          = "tcp"
    security_group_id = aws_security_group.my-asg-sg.id
    to_port           = 22
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
    from_port         = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.my-asg-sg.id
    to_port           = 80
    type              = "ingress"
    cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
    from_port         = 0
    protocol          = "-1"
    security_group_id = aws_security_group.my-asg-sg.id
    to_port           = 0
    type              = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
}