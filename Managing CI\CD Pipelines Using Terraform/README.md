The DevOps team is designing a Terraform-based infrastructure to simulate real-world, production-grade deployments with strict adherence to best practices. The infrastructure must be reusable, modular, and environment-specific (dev and prod).
Requirements:
Create modules under modules/ named:
dynamodb:Provision a DynamoDB table named xfusion-<env>-table (based on the environment)(dev & prod), using id as the HASH key.
secretsmanager: to provision a Secrets Manager secret named xfusion-<env>-secret.
elasticsearch: to provision an Elasticsearch domain named xfusion-<env>-es.
Create a secret value xfusion-<env>-value.(dev & prod).
Each environment dev and prod MUST be located under /home/bob/terraform/env/. Terraform commands will be executed from within each environment directory.
Use absolute-path symbolic links (/home/bob/terraform/) in each environment dev/prod for the shared Terraform files main.tf, variables.tf, and shared modules. Within each environment directory, the modules/ directory MUST be a symbolic link pointing to /home/bob/terraform/modules.
Keep a separate terraform_config.tf in each environment to define environment-specific configuration modules, environment variables, overrides. This file should NOT be a symlink.
Use main.tf file under /home/bob/terraform to define all shared resources and environment-specific modules, ensuring clarity, modularity, and maintainability.
Use the variables.tf file under /home/bob/terraform with the following variables:
KKE_ENV: name of the Environment used.(dev or prod)
KKE_DYNAMODB_TABLE_NAME: name of the dynamodb table.
KKE_SECRET_NAME: name of the secret.
KKE_SECRET_VALUE: secret value.
KKE_ELASTICSEARCH_DOMAIN: domain of the elasticsearch.
Use dev.tfvars and prod.tfvars with respect to the variables.tf file under /home/bob/terraform/env/<env-name>/. Terraform plans will be executed using these files explicitly.
Use the following variables to output the following:
kke_table_name:exposes the name of the created DynamoDB table
kke_secret_arn :provides the ARN of the Secrets Manager secret
kke_elasticsearch_endpoint: returns the endpoint of the Elasticsearch domain

Notes:
The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Ensure all environment directories reference shared modules via symlinks and no module code is duplicated.

Ensure that the variables.tf and main.tf files in each environment directory use absolute-path symbolic links.

Resources must be named uniquely per environment.

Before submitting the task, ensure that terraform plan returns No changes. Your infrastructure matches the configuration.
