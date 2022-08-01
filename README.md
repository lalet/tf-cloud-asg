# Terraform cloud Hello World Flask Application

**Application Link** : [URL](https://terraform-elb-staging-762515498.us-west-2.elb.amazonaws.com)

[![Terraform](https://github.com/lalet/tf-cloud-asg/actions/workflows/terraform.yml/badge.svg?branch=main)](https://github.com/lalet/tf-cloud-asg/actions/workflows/terraform.yml)

### AMI Creation
Used the Ubuntu 20 AMI from amazon, installed the flask application and used gunicorn to start the server, nginx as proxy and took a snapshot of the image to be used as base ami [Reference](https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-18-04)

### Terraform Pre-requisites
 - Base ami that can serve the flask application on startup (default : ami-0bf93727c047adcf1)
 - Self signed certificate or amazon issued certificate for https listener in the loadbalancer (default: "arn:aws:acm:us-west-2:306984394133:certificate/16c563ab-166e-4725-8b5f-fa775f50d9f3"). [Link](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request-public.html)
 - VPC routing is in place in case the application is deployed on private vpc (used the default vpc)
- SNS module doesn't fully support email at the moment as a [protocol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#:~:text=protocol%20%2D%20(Required)), so had to manually create a topic and subscription and add it to cloudwatch action (default: arn:aws:sns:us-west-2:306984394133:cpu_asg_alarm:e21cbd79-b859-4474-bc0a-9ceff032572d)
- Modular TF code can serve multiple environments, we will have to create separate workspaces for each environment, by creating a new folder, setup terraform cloud workspace pointing to newer directory and update to the github action yaml to act on changes or pull request to the newer directory
- Github Actions gets triggered on each pull request and applied on merge to main branch (Reference)[https://github.com/marketplace/actions/hashicorp-setup-terraform]

### Workflow
 * An autoscaling group is created that is triggered based on cloudwatch cpu utilization, min number of instances is 2 and maximum is 10. Everytime the cloudwatch alarm goes off, an autoscaling policy kicks in if the current number of instance is with in limit, either it increments or decrements based on load and an email is sent out.
 * The autoscaling group sits behind a load balancer that serves traffic only in https mode, the current deployment uses a self signed certificate but you can ignore the warning and move ahead
 * Every time a push is made to main branch, terraform cloud code is applied if plan is successful. For every pull request a plan is ran on the branch to see if the changes are good. [Link](https://github.com/lalet/tf-cloud-asg/actions)

### Improvements
 - Image bake using packer or ansible instead of manual snapshot
 - Use an application load balancer to redirect http traffic to https traffic
 - Parameterize cpu utilization threshold (default thresholds: low load = 20, high load = 80 over a period of 120 seconds)
 - Use aws cli with local exec to create sns topic and subscription for email
 - More intelligent routing based on paths on load balancer


