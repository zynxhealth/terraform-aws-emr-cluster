# terraform-aws-emr-cluster

A Terraform module to create an Amazon Web Services (AWS) Elastic MapReduce (EMR) cluster.

_Forked from <https://github.com/azavea/terraform-aws-emr-cluster> to support additional EMR
features. See [CHANGELOG](https://github.com/chrissng/terraform-aws-emr-cluster/releases)_

## Usage

```hcl
data "template_file" "emr_configurations" {
  template = "${file("configurations/default.json")}"
}

module "emr" {
  source = "github.com/chrissng/terraform-aws-emr-cluster?ref=0.3-emr5"

  name          = "DataprocCluster"
  vpc_id        = "vpc-20f74844"
  custom_ami_id = "${module.emr.default_ami_id}"
  release_label = "emr-5.9.0"

  applications = [
    "Hadoop",
    "Ganglia",
    "Spark",
    "Zeppelin",
  ]

  configurations = "${data.template_file.emr_configurations.rendered}"
  key_name       = "hector"
  subnet_id      = "subnet-e3sdf343"

  instance_groups = [
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "m3.xlarge"
      instance_count = "1"
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "m3.xlarge"
      instance_count = "1"
      bid_price      = "0.30"
      autoscaling_policy = <<EOF
{
"Constraints": {
  "MinCapacity": 1,
  "MaxCapacity": 2
},
"Rules": [
  {
    "Name": "ScaleOutMemoryPercentage",
    "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
    "Action": {
      "SimpleScalingPolicyConfiguration": {
        "AdjustmentType": "CHANGE_IN_CAPACITY",
        "ScalingAdjustment": 1,
        "CoolDown": 300
      }
    },
    "Trigger": {
      "CloudWatchAlarmDefinition": {
        "ComparisonOperator": "LESS_THAN",
        "EvaluationPeriods": 1,
        "MetricName": "YARNMemoryAvailablePercentage",
        "Namespace": "AWS/ElasticMapReduce",
        "Period": 300,
        "Statistic": "AVERAGE",
        "Threshold": 15.0,
        "Unit": "PERCENT"
      }
    }
  }
]
}
EOF
    },
  ]

  bootstrap_name = "runif"
  bootstrap_uri  = "s3://elasticmapreduce/bootstrap-actions/run-if"
  bootstrap_args = []
  log_uri        = "s3n://.../"

  project     = "Something"
  environment = "Staging"
}
```

## Instance Group Example

```hcl
[
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "m3.xlarge"
      instance_count = 1
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "m3.xlarge"
      instance_count = "1"
      bid_price      = "0.30"
    },
]
```

## Inputs

| Name                              | Description                                                                       |  Type  |   Default   | Required |
| --------------------------------- | --------------------------------------------------------------------------------- | :----: | :---------: | :------: |
| additional_master_security_groups | Additional master security groups to place the EMR EC2 instances in               | string |      -      |   yes    |
| applications                      | List of EMR release applications                                                  |  list  |  `<list>`   |    no    |
| bootstrap_args                    | List of arguments to the bootstrap action script                                  |  list  |  `<list>`   |    no    |
| bootstrap_name                    | Name for the bootstrap action                                                     | string |      -      |   yes    |
| bootstrap_uri                     | S3 URI for the bootstrap action script                                            | string |      -      |   yes    |
| configurations                    | JSON array of EMR application configurations                                      | string |      -      |   yes    |
| custom_ami_id                     | Custom AMI ID to base the EMR EC2 instance on                                     | string |      -      |   yes    |
| environment                       | Name of environment this cluster is targeting                                     | string |  `Unknown`  |    no    |
| instance_groups                   | List of objects for each desired instance group                                   |  list  |  `<list>`   |    no    |
| key_name                          | EC2 key pair name                                                                 | string |      -      |   yes    |
| log_uri                           | S3 URI of the EMR log destination, must begin with `s3n://` and end with trailing | string |      -      |   yes    |
| name                              | Name of EMR cluster                                                               | string |      -      |   yes    |
| project                           | Name of project this cluster is for                                               | string |  `Unknown`  |    no    |
| release_label                     | EMR release version to use                                                        | string | `emr-5.7.0` |    no    |
| subnet_id                         | Subnet used to house the EMR nodes                                                | string |      -      |   yes    |
| vpc_id                            | ID of VPC meant to house cluster                                                  | string |      -      |   yes    |

## Outputs

| Name                                            | Description                                                                         |
| ----------------------------------------------- | ----------------------------------------------------------------------------------- |
| default_ami_id                                  | The most recent suitable AMI ID for EMR to base on                                  |
| iam_emr_autoscaling_assume_role_policy          | The policy that grants an entity permission to assume the EMR autoscaling role      |
| iam_emr_autoscaling_role                        | The name of the EMR autoscaling role                                                |
| iam_emr_autoscaling_role_arn                    | The Amazon Resource Name (ARN) specifying the EMR autoscaling role                  |
| iam_emr_autoscaling_role_policy_arn             | The ARN of the policy applied to the EMR autoscaling role                           |
| iam_emr_autoscaling_role_unique_id              | The stable and unique string identifying the EMR autoscaling role                   |
| iam_emr_ec2_instance_profile_assume_role_policy | The policy that grants an entity permission to assume the EC2 instance profile role |
| iam_emr_ec2_instance_profile_policy_arn         | The ARN of the policy applied to the EC2 instance profile role                      |
| iam_emr_ec2_instance_profile_role               | The name of the EC2 instance profile role                                           |
| iam_emr_ec2_instance_profile_role_arn           | The Amazon Resource Name (ARN) specifying the EC2 instance profile role             |
| iam_emr_ec2_instance_profile_role_unique_id     | The stable and unique string identifying the EC2 instance profile role              |
| iam_emr_service_assume_role_policy              | The policy that grants an entity permission to assume the EMR service role          |
| iam_emr_service_role                            | The name of the EMR service role                                                    |
| iam_emr_service_role_arn                        | The Amazon Resource Name (ARN) specifying the EMR service role                      |
| iam_emr_service_role_policy_arn                 | The ARN of the policy applied to the EMR service role                               |
| iam_emr_service_role_unique_id                  | The stable and unique string identifying the EMR service role                       |
| id                                              | The ID of the EMR cluster                                                           |
| master_public_dns                               | The public DNS name of the master EC2 instance                                      |
| master_security_group_id                        | The ID of the security group for master instance                                    |
| name                                            | The name of the cluster                                                             |
| slave_security_group_id                         | The ID of the security group for client instance                                    |
