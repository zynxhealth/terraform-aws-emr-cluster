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

## Variables

- `name` - Name of EMR cluster
- `vpc_id` - ID of VPC meant to house cluster
- `release_label` - EMR release version to use (default: `emr-5.8.0`)
- `applications` - A list of EMR release applications (default: `["Spark"]`)
- `configurations` - JSON array of EMR application configurations
- `key_name` - EC2 Key pair name
- `subnet_id` - Subnet used to house the EMR nodes
- `instance_groups` - List of objects for each desired instance group (see section below)
- `bootstrap_name` - Name for the bootstrap action
- `bootstrap_uri` - S3 URI for the bootstrap action script
- `bootstrap_args` - A list of arguments to the bootstrap action script (default: `[]`)
- `log_uri` - S3 URI of the EMR log destination, must begin with `s3n://` and end with trailing
  slashes
- `project` - Name of project this cluster is for (default: `Unknown`)
- `environment` - Name of environment this cluster is targeting (default: `Unknown`)

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

## Outputs

- `id` - The EMR cluster ID
- `name` - The EMR cluster name
- `master_public_dns` - The EMR master public FQDN
- `master_security_group_id` - Security group ID of the master instance/s
- `slave_security_group_id` - Security group ID of the slave instance/s
