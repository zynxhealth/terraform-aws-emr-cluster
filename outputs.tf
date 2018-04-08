output "id" {
  value = "${aws_emr_cluster.cluster.id}"
}

output "name" {
  value = "${aws_emr_cluster.cluster.name}"
}

output "master_public_dns" {
  value = "${aws_emr_cluster.cluster.master_public_dns}"
}

output "master_security_group_id" {
  value = "${aws_security_group.emr_master.id}"
}

output "slave_security_group_id" {
  value = "${aws_security_group.emr_slave.id}"
}

output "iam_emr_service_role" {
  value = "${aws_iam_role.emr_service_role.name}"
}

output "iam_emr_service_assume_role_policy" {
  value = "${aws_iam_role.emr_service_role.assume_role_policy}"
}

output "iam_emr_service_role_policy_arn" {
  value = "${aws_iam_role_policy_attachment.emr_service_role.policy_arn}"
}

output "iam_emr_ec2_instance_profile_role" {
  value = "${aws_iam_role.emr_ec2_instance_profile.name}"
}

output "iam_emr_ec2_instance_profile_assume_role_policy" {
  value = "${aws_iam_role.emr_ec2_instance_profile.assume_role_policy}"
}

output "iam_emr_ec2_instance_profile_policy_arn" {
  value = "${aws_iam_role_policy_attachment.emr_ec2_instance_profile.policy_arn}"
}

output "iam_emr_autoscaling_role" {
  value = "${aws_iam_role.emr_autoscaling_role.name}"
}

output "iam_emr_autoscaling_assume_role_policy" {
  value = "${aws_iam_role.emr_autoscaling_role.assume_role_policy}"
}

output "iam_emr_autoscaling_role_policy_arn" {
  value = "${aws_iam_role_policy_attachment.emr_autoscaling_role.policy_arn}"
}
