cd $1/$2
packer init .
cd ../..
packer build \
 -var-file="vsphere.pkrvars.hcl" \
 -var-file="common.pkrvars.hcl" \
 -var-file="build.pkrvars.hcl" \
 -var-file="ansible.pkrvars.hcl" \
 -var-file="$1/$2/$1.pkrvars.hcl" \
 -var-file="hardware/$3.pkrvars.hcl" \
 -force ./ubuntu/22-10
