## Keyngo - Deploy KioskJ
## This role has been created to deploy and update the KioskJ application and requeriments.
## The playbook will manage the local nginx pool turning off the instances before update 

## VARS:

## List of vars:

keyngo_kioskj_op	: setup|distribute|prepare|deploy The operation to execute in the target host
keyngo_kioskj_version	: version to deploy

## List of related playbooks

### playbooks/rentalcar.keyngo/keyngo/kioskj_deploy.yml

Main playbook that allows to execute the required task over the defined instances of the kioskj application

To execute the playbook only for some instnaces use the --limit="..." flag

#### Execution sample

ansible-playbook -i environments/lab/ playbooks/rentalcar.keyngo/keyngo/kioskj_deploy.yml --vault-password-file ~/.vault_pass.txt --extra-vars="keyngo_kioskj_op=deploy keyngo_kioskj_version=3.01.000"
