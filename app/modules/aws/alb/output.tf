output "alb" {
  value = aws_lb.this
}

output "aws_lb_listener" {
  value = aws_lb_listener.http
}

output "aws_lb_target_group" {
  value = aws_lb_target_group.this
}

output "aws_lb_target_group_attachment" {
  value = aws_lb_target_group_attachment.this
}

output "aws_lb_listener_rule" {
  value = aws_lb_listener_rule.this
}
