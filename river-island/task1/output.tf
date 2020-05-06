output "DNS-Records" {
  value = {
#  value = "${aws_route53_record.www.name}, ${aws_route53_record.www.fqdn}"
    for key, value in aws_route53_record.www:
    key => { RecordFQDN: value.fqdn }
}
}
