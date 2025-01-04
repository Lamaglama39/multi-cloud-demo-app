resource "aws_lb" "this" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  subnets            = var.alb_subnet
  security_groups    = var.alb_security_groups
}

resource "aws_lb_target_group" "this" {
  for_each = var.path_config

  name        = "tg-${each.key}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = var.path_config

  target_group_arn  = aws_lb_target_group.this[each.key].arn
  target_id         = each.value.ip
  availability_zone = each.value.availability_zone
  port              = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  # デフォルトアクション: 全ターゲットグループにランダム分散
  default_action {
    type = "forward"
    forward {
      dynamic "target_group" {
        for_each = aws_lb_target_group.this
        content {
          arn    = target_group.value.arn
          weight = 1
        }
      }
    }
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = var.path_config

  listener_arn = aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
  condition {
    path_pattern {
      values = ["/${each.key}*", "/${each.key}/*"]
    }
  }
}
