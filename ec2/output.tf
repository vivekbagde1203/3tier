output instance1 {
    value = "${element(aws_instance.web.*.id, 1)}"
}
output instance2 {
    value = "${element(aws_instance.web.*.id, 2)}"
}
output instance3 {
    value = "${element(aws_instance.web-private.*.id, 1)}"
}
output instance4 {
    value = "${element(aws_instance.web-private.*.id, 2)}"
}
