output "alb_arn" {
  value = aws_lb.alb.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "zone_id" {
  value = aws_lb.alb.zone_id
}

output "http_listener_arn" {
  value = aws_lb_listener.alb-http.arn
}
