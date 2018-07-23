output "id" {
  description = "The ID of the EMR cluster"
  value       = "${aws_emr_cluster.cluster.id}"
}

output "name" {
  description = "The name of the cluster"
  value       = "${aws_emr_cluster.cluster.name}"
}

output "master_public_dns" {
  description = "The public DNS name of the master EC2 instance"
  value       = "${aws_emr_cluster.cluster.master_public_dns}"
}

output "master_security_group_id" {
  description = "The ID of the security group for master instance"
  value       = "${aws_security_group.emr_master.id}"
}

output "slave_security_group_id" {
  description = "The ID of the security group for client instance"
  value       = "${aws_security_group.emr_slave.id}"
}

output "iam_emr_service_role" {
  description = "The name of the EMR service role"
  value       = "${aws_iam_role.emr_service_role.name}"
}

output "iam_emr_service_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the EMR service role"
  value       = "${aws_iam_role.emr_service_role.arn}"
}

output "iam_emr_service_role_unique_id" {
  description = "The stable and unique string identifying the EMR service role"
  value       = "${aws_iam_role.emr_service_role.unique_id}"
}

output "iam_emr_service_assume_role_policy" {
  description = "The policy that grants an entity permission to assume the EMR service role"
  value       = "${aws_iam_role.emr_service_role.assume_role_policy}"
}

output "iam_emr_service_role_policy_arn" {
  description = "The ARN of the policy applied to the EMR service role"
  value       = "${aws_iam_role_policy_attachment.emr_service_role.policy_arn}"
}

output "iam_emr_ec2_instance_profile_role" {
  description = "The name of the EC2 instance profile role"
  value       = "${aws_iam_role.emr_ec2_instance_profile.name}"
}

output "iam_emr_ec2_instance_profile_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the EC2 instance profile role"
  value       = "${aws_iam_role.emr_ec2_instance_profile.arn}"
}

output "iam_emr_ec2_instance_profile_role_unique_id" {
  description = "The stable and unique string identifying the EC2 instance profile role"
  value       = "${aws_iam_role.emr_ec2_instance_profile.unique_id}"
}

output "iam_emr_ec2_instance_profile_assume_role_policy" {
  description = "The policy that grants an entity permission to assume the EC2 instance profile role"
  value       = "${aws_iam_role.emr_ec2_instance_profile.assume_role_policy}"
}

output "iam_emr_ec2_instance_profile_policy_arn" {
  description = "The ARN of the policy applied to the EC2 instance profile role"
  value       = "${aws_iam_role_policy_attachment.emr_ec2_instance_profile.policy_arn}"
}

output "iam_emr_autoscaling_role" {
  description = "The name of the EMR autoscaling role"
  value       = "${aws_iam_role.emr_autoscaling_role.name}"
}

output "iam_emr_autoscaling_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the EMR autoscaling role"
  value       = "${aws_iam_role.emr_autoscaling_role.arn}"
}

output "iam_emr_autoscaling_role_unique_id" {
  description = "The stable and unique string identifying the EMR autoscaling role"
  value       = "${aws_iam_role.emr_autoscaling_role.unique_id}"
}

output "iam_emr_autoscaling_assume_role_policy" {
  description = "The policy that grants an entity permission to assume the EMR autoscaling role"
  value       = "${aws_iam_role.emr_autoscaling_role.assume_role_policy}"
}

output "iam_emr_autoscaling_role_policy_arn" {
  description = "The ARN of the policy applied to the EMR autoscaling role"
  value       = "${aws_iam_role_policy_attachment.emr_autoscaling_role.policy_arn}"
}

output "default_ami_id" {
  description = "The most recent suitable AMI ID for EMR to base on"
  value       = "${data.aws_ami.default.image_id}"
}

output "tags" {
  description = "Tags applied to all EMR instances"
  value       = "${aws_emr_cluster.cluster.tags}"
}
