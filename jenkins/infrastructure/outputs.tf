output "jenkins_private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "jenkins_alb_target_group_arn" {
  value = "${module.alb.target_group_arns[0]}"
}

output "jenkins_security_group" {
    value = "${aws_security_group.jenkins.id}"
}


