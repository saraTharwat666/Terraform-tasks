The Nautilus DevOps team needs to set up three S3 buckets for different environments with backup and policy configurations. Follow the steps below:

Create three S3 buckets using for_each for environments: Dev, Staging, and Prod.

Name the buckets using the following naming convention:

nautilus-dev-bucket-27566
nautilus-staging-bucket-27566
nautilus-prod-bucket-27566
Add the following tags to each bucket with the corresponding values:

a.) For nautilus-dev-bucket-27566:

Name = nautilus-dev-bucket-27566
Environment = Dev
Owner = Alice
b.) For nautilus-staging-bucket-27566:

Name = nautilus-staging-bucket-27566
Environment = Staging
Owner = Bob
c.) For nautilus-prod-bucket-27566:

Environment = Prod
Owner = Carol
For the staging and prod buckets, set Backup = true and add a lifecycle rule with ID MoveToGlacier to transition objects to Glacier after 30 days.

Use the lifecycle block with ignore_changes to protect the tags.

Create a bucket policy that allows public read access to all objects in the bucket.

Use depends_on to ensure the policy is only applied after the bucket has been created.

Implement the entire configuration in a single main.tf file (do not create a separate .tf file) to provision multiple S3 buckets with the specified configurations.

Use variables.tf with the following variable:

KKE_ENV_TAGS. KKE_ENV_TAGS is a map that holds environment-specific metadata such as bucket name, owner, and backup flag.
Use outputs.tf file to output the following:

kke_bucket_names: output the names of the bucket created.

Notes:

The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Before submitting the task, ensure that terraform plan returns No changes. Your infrastructure matches the configuration.
