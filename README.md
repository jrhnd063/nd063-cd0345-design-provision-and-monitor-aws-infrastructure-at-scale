# nd063-cd0345-design-provision-and-monitor-aws-infrastructure-at-scale

Project for Design, Provision and Monitor AWS Infrastructure at Scale

## Create AWS Architecture Schematics

### Part 1: Social Media App

The architecture diagram is [Udacity_Diagram_1.pdf](diagrams/Udacity_Diagram_1.pdf).

### Part 2: Serverless App

The architecture diagram is [Udacity_Diagram_2.pdf](diagrams/Udacity_Diagram_2.pdf).

## Calculate Infrastructure Costs

### Initial Cost Estimate

Targeting a monthly estimate of $8000-$10000 in `us-east-1` the initial cost estimates are [Initial_Cost_Estimate.csv](tables/Initial_Cost_Estimate.csv).

This is based on the following assumptions:

* The average user (accounting for both very active and very inactive users) uploads 150MB per month of photos and videos, consisting of two 50MB videos and 25 2MB photos.
* The average user views/downloads 1GB per month of photos and videos.
* The average user makes 1 post per day of 1KB.
* The application servers do some processing on user generated content and the user graph that necessitates them having more resource than the Web server.

### Reduced Cost Estimate

Refining estimates would ideally be based on having monitored the performance of the infrastructure in production and identified where it is over-provisioned. However, given we are reducing the estimate at the pre-production stage, we do not have this data. We don't want to reduce the features available to users, for example by introducing caps on the amount of content that they can create, or to reduce the resilience of the system by swapping to a single AZ setup, so we opt to:

* Reduce the size of the apps servers, since we lack data to justify `m5.2xlarge` being required.
* Reduce the size of the database instance to `db.m2.2xlarge` with the same reasoning.
* Assume that our 100% provisioned Web and App servers represent the minimum capacity we will need at all times, and purchase that capacity on a one-year savings plan; the burst capacity for auto-scaling remains on-demand.

### Increased Cost Estimate

To increase the resilience and performance with a budget of $20000, we can make the following changes:

* Switch to a mult-region setup to provide service even if an event affects `us-east-1`. Given the users are stated to be single-region, the alternative region should be close; `us-east-2` was selected as it should not provide appreciably different latency for Virginia region users. The new region contains a VPC with a multi-AZ, asynchronous read-replica of the Postgres database, plus the same setup as the primary region in terms of Web and Application servers.
* Increase database instance size and double the number of database read-replicas to alleviate read pressure on the database.
* Increase the number of constant EC2 Web and App servers from 4 to 6 and double the burst capacity available to their auto-scaling groups by increasing the number of 25% available instances from 4 to 8.

## Use Terraform to Provision AWS Infrastructure

### Part 1

With a terraform working directory containing [main.tf](terraform/Exercise_1_code/main.tf), run:

* `terraform init`
* `terraform plan -out create-ec2s-plan`
* `terraform apply "create-ec2s-plan"`

Screenshot of the six instances is [Terraform_1_1.png](terraform/Terraform_1_1.png).

Modify the `main.tf` to remove the m4 instances per the state shown in [main_destroy_m4.tf](terraform/Exercise_1_code/main_destroy_m4.tf), then run:

* `terraform plan -out destroy-m4s-plan`
* `terraform apply "destroy-m4s-plan"`

Screenshot with the two terminated `m4.large` is [Terraform_1_2.png](terraform/Terraform_1_2.png).

### Part 2

In a new terraform working directory, place the files in the [Exercise_2_code directory](terraform/Exercise_2_code).

Run:

* `terraform init`
* `terraform plan -out deploy-lambda-and-roles`
* `terraform apply "deploy-lambda-and-roles"`

Screenshot of the EC2 instances showing the four `t2.micro` still running is [Terraform_2_1.png](terraform/Terraform_2_1.png).

Screenshot of the VPC they are deployed to is [Terraform_2_2.png](terraform/Terraform_2_2.png).

Screenshot of the CloudWatch log for the Lambda is [Terraform_2_3.png](terraform/Terraform_2_3.png).

## Destroy the Infrastructure using Terraform and prepare for submission

In both terraform working directories, run:

* `terraform plan -destroy -out destroy-plan`
* `terraform apply "destroy-plan"`

Screenshot of the destroyed EC2 instances is [Terraform_destroyed.png](terraform/Terraform_destroyed.png).

