locals {
  userdata = templatefile("userdata.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}

resource aws_instance "cw"{
    ami= "ami-0761dd91277e34178"
    instance_type = "t2.micro" 
    vpc_security_group_ids = [aws_security_group.cloudwatch.id]
    iam_instance_profile = aws_iam_instance_profile.cw_role_instanceprofile.name
    #count = var.COUNT 
    user_data = local.userdata
    tags = {
      Name = "Cloudwatch_tf"
    }
       
}

resource "aws_ssm_parameter" "cw_agent" {
    description = "Cloudwatch agent config to configure custom log"
    name        = "/cloudwatch-agent/config"
    type        = "String"
    value       = file("cw_agent_config.json")
}

output "public_ip" {
    value = join(",", aws_instance.cw.*.public_ip)
}
