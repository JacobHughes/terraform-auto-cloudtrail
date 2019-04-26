set -euo pipefail

echo "Now building infrastructure environment using terraform"

cd src/terraform
terraform init
terraform get

terraform apply -auto-approve tf.plan

echo "Terraform complete, please check the status of your resources to confirm deployment"
