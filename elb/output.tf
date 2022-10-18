output "alb_dns_name" {
    value = "${aws_lb.dev-alb.dns_name}"
}

output "alb_target_group_arn" {
    value = "${aws_lb_target_group.my-test.arn}"
}