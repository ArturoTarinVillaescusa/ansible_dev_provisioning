## SUMMARY	: Role to deploy MSSTEFOperationsWebNotifications
## COMPANY	: RENTALCAR
## SQUAD  	: NOVABASE

## >>> TODO <<< 

## >>>>>><<<<<< 


## >>> VARS <<< 

### Inventory:

#### hosts:
All the host groups prefixed with mssown_*
#### Group vars:
All of this vars can be used inside the role.

group_vars/all/*

group_vars/mssown.yml

group_vars/mssown_mss.yml


### Extra-vars:
mssown_mss_op: Select the last stage to be executed from the deploy pipeline, valid values are:


.- setup: Ensures that all the affected target host are ready an propperly configured to host the microservice [ Environment vars, Network connectivity, Firewall rules, etc... ]

.- distribute: Ensures that all the required binaries and files are present in the target(s) host(s) [ both at the application and system level ]

.- prepare: Ensures that all the requiriments are installed in the target host, and also deploys the new version artifacts in a tmp path

.- deploy: Deploys the new version in the target host [ moving the new version from the tmp path generated in the prepare stage ]

## >>>>>><<<<<< 

## >>> PLAYBOOKS <<<

### rentalcar.novabase/mssown/mss_deploy.yml

This playbook manages the deployment of the relevant microservice, the deploy pipeline is defined following some cumulative stages that can be selected through the mssown_mss_op param

### Required vars:
mssown_mss_op

### Optional vars:
.- Any Inventory level var can be overwritten if required

## >>>>>><<<<<< 
