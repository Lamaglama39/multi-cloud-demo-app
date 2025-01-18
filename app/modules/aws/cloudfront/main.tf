data "aws_cloudfront_cache_policy" "main" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "main" {
  name = "Managed-AllViewer"
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 4.1.0"

  comment             = "CloudFront with ALB Origin (No Cache)"
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  origin = {
    alb = {
      domain_name = var.alb_domain_name
      origin_id   = "alb-origin"

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    use_forwarded_values   = false

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id          = data.aws_cloudfront_cache_policy.main.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.main.id

    compress = true
  }
}
