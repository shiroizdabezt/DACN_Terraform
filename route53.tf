resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.tuilalinh_zone.id
  name    = "tuilalinh.id.vn"
  type    = "A"
  ttl     = 300
  records = [aws_eip.public_ip_frontend.public_ip]
}

resource "aws_route53_zone" "tuilalinh_zone" {
  name = "tuilalinh.id.vn"
}

resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.tuilalinh_zone.id
  name    = "api.tuilalinh.id.vn"
  type    = "A"
  ttl     = 300
  records = [aws_eip.public_ip_backend.public_ip]
}


resource "aws_route53_record" "admin" {
  zone_id = aws_route53_zone.tuilalinh_zone.id
  name    = "admin.tuilalinh.id.vn"
  type    = "A"
  ttl     = 300
  records = [aws_eip.public_ip_admin.public_ip]
}

