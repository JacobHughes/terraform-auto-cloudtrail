set -euo pipefail
echo "Now destroying all Terraform resources"

cd src/terraform
terraform init
terraform get

terraform destroy -auto-approve

echo "Teardown complete"