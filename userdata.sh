#! /bin/bash
set -e #exit the script at the occurrence of first error

# Ouput all log
exec > >(tee /var/log/user-data.log|logger -t user-data-extra -s 2>/dev/console) 2>&1

# Make sure we have all the latest updates when we launch this instance
sudo yum update -y
sudo yum upgrade -y
sudo yum install httpd -y
sudo service httpd start
echo "<h1> Deployed via terraform ***Priyadarshini Itraj*** </h1>" | sudo tee /var/www/html/index.html
# Configure Cloudwatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm #-U will update if the repo is upgradable

# Use cloudwatch config from SSM
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \ #In this command, -a fetch-config causes the agent to load the latest version of the CloudWatch agent configuration file
-m ec2 \
-c ssm:${ssm_cloudwatch_config} -s #-s starts the agent
