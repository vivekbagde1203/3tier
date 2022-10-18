output instance1 {
    value = "${element(aws_instance.web.*.id, 1)}"
}
output instance2 {
    value = "${element(aws_instance.web.*.id, 2)}"
}
