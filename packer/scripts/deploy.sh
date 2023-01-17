cd ubuntu/22-10
packer init .
cd ../..
packer build \
 -var-file="vsphere.pkrvars.hcl" \
 -var-file="common.pkrvars.hcl" \
 -var-file="build.pkrvars.hcl" \
 -var-file="ansible.pkrvars.hcl" \
 -var-file="ubuntu/22-10/ubuntu.pkrvars.hcl" \
 -var-file="hardware/large.pkrvars.hcl" \
 -force ./ubuntu/22-10
