set -euo pipefail
echo "Now building infrastructure environment using terraform"
echo "Resources will be created using the backend configuration in src/config.tf"
echo "The Terraform plan will be saved into tf.plan"

cd src
terraform init
terraform get

terraform fmt

terraform plan -out tf.plan

echo "Terraform complete, please check the status of your resources to confirm deployment"