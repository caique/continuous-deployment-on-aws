module "infrastructure" {
  source = "./infrastructure"
}

resource "aws_ecs_cluster" "jenkins" {
	name = "jenkins"
}

resource "aws_ecs_task_definition" "jenkins" {
  family                    = "jenkins"
  container_definitions     = "${file("jenkins/definitions/task-definition.json")}"
  network_mode              = "awsvpc"
  cpu                       = "1024"
  memory                    = "2048"
  requires_compatibilities  = ["FARGATE"]
}

resource "aws_ecs_service" "jenkins" {
	name                               = "jenkins"
  cluster                            = "${aws_ecs_cluster.jenkins.id}"
  task_definition                    = "${aws_ecs_task_definition.jenkins.arn}"
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "100"
  deployment_minimum_healthy_percent = "0"

  network_configuration {
    subnets          = "${module.infrastructure.jenkins_private_subnets}"
    security_groups  = ["${module.infrastructure.jenkins_security_group}"]
    assign_public_ip = "false"
  }

  load_balancer {
    container_name   = "jenkins"
    container_port   = 8080
    target_group_arn = "${module.infrastructure.jenkins_alb_target_group_arn}"
  }
}
