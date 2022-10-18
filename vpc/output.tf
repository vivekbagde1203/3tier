output "aws_vpc_id" {
  value = aws_vpc.dev-vpc.id
}
output "aws_internet_gateway" {
  value = aws_internet_gateway.dev-igw.id
}
output "security_group" {
  value = aws_security_group.dev-sg.id
}
output "subnet" {
  value = "${aws_subnet.public-subnet.*.id}"
}
output "subnet11" {
  value = "${element(aws_subnet.public-subnet.*.id, 1 )}"
}
output "subnet22" {
  value = "${element(aws_subnet.public-subnet.*.id, 2 )}"
}
output "private-subnet1" {
  value = "${element(aws_subnet.private-subnet.*.id, 1 )}"
}
output "private-subnet2" {
  value = "${element(aws_subnet.private-subnet.*.id, 2 )}"
}
output "db-private-subnet1" {
  value = "${element(aws_subnet.db-private-subnet.*.id, 1 )}"
}
output "db-private-subnet2" {
  value = "${element(aws_subnet.db-private-subnet.*.id, 2 )}"
}