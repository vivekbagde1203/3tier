resource "aws_lb_target_group" "my-test" {
    health_check {
        interval = 10
        path = "/"
        protocol = "HTTP"
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold  = 2
    }
    
    name        = "dev-alb-group"
    port        = 80
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = var.dev-vpc
}

resource "aws_lb_target_group_attachment" "test-targetgroup-1" {
    target_group_arn = aws_lb_target_group.my-test.arn
    target_id        = var.instance1_id
    port             = 80
}

resource "aws_lb_target_group_attachment" "test-targetgroup-2" {
    target_group_arn = aws_lb_target_group.my-test.arn
    target_id        = var.instance2_id
    port             = 80
}

resource "aws_lb" "dev-alb" {
    name               = "dev-alb"
    internal           = false
    load_balancer_type = "application"

    security_groups    = [aws_security_group.lb-sg.id]
    
    subnets            = ["var.subnet1","var.subnet2"]

    #access_logs {
    #    bucket  = aws_s3_bucket.lb_logs.bucket
    #    prefix  = "test-lb"
    #    enabled = true
    #}

    tags = {
        Environment = "dev"
    }
}
resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.dev-alb.arn
    port              = "80"
    protocol          = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.my-test.arn
    }
}
resource "aws_security_group" "lb-sg" {
    name = "lb-sg"
    vpc_id = var.dev-vpc
}
resource "aws_security_group_rule" "inbound-http" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.lb-sg.id}"
}
resource "aws_security_group_rule" "outbound-all" {
    type              = "egress"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.lb-sg.id}"
}