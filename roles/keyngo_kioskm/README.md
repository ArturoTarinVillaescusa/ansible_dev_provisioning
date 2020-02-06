## Keyngo - Deploy KioskM
## This role has been created to deploy and update the KioskM application and requeriments.
##

## IMPORTANT ##

THE kioskm_fetch=no option is not working with artifacts and big files due a problem sending big files trought winrm. This files must be copied manually in the target host before launch the playbook

###############


## VARS:

## List of vars:

kioksm_devices	: Target devices  
kioskm_version	: Target version to deploy   
kioskm_restart	: yes|no -> Flag, if yes the application will be restarted after run the playbook   
kioksm_reboot	:  yes|no -> Flag, if yes the system will be rebooted after run the playbook   
kioskm_fetch    : yes|no -> Flag, if yes the nexus artifacts are downloaded from target host. If no the script assumes that the binary is alredy hosted in the target host

kioskm_op	: Operation to execute, this var is setted at playbook level, there are different playbooks for each operation.  

## List of related playbooks

### keyngo_kioskm_setup 

This playbook prepares the system to host the application and the requiriments, no software is distributed or installed. Check the tasks/setup.yml file inside the role for more info.

### Required vars:
kioskm_devices	  

### Optional vars:
kioskm_restart   
kioskm_reboot   

### keyngo_kioskm_distribute.yaml

This playbook Ensures that the required software and application binaries is present in the target device. Check the tasks/distribute.yml file inside the role for more info.

### Required vars:
kioskm_devices   
kioskm_fetch

### Optional vars:
kioskm_version   
kioskm_restart   
kioskm_reboot   

### keyngo_kioskm_prepare.yaml

This playbook Ensured that the required software is installed in the target devices. Check the tasks/prepare.yml file inside the role for more info.

### Required vars:
kioskm_devices 
kioskm_fetch

### Optional vars:
kioskm_restart   
kioskm_reboot   


### keyngo_kioskm_deploy.yaml

This playbook deploys the selected version of the software in the selected devices, application is alwais restarted after deploy. Check the tasks/deploy.yml file inside the role for more info. 

### Required vars:
kioskm_devices 
kioskm_version 
kioskm_fetch

### Optional vars:
kioskm_reboot 

### keyngo_kioskm_check.yaml

This playbooks performs some checks over the selected devices. Check the tasks/check.yml file inside the role for more info. 

### Required vars:
kioskm_devices 

### Optional vars:
kioskm_restart   
kioskm_reboot   


### Execution sample

### Deploy a new version in cen_kiosk1 and cen_kiosk2 devices, fetching nexus artifacts from target host

ansible-playbook -i environments/keyngo_kioskm/main.yaml playbooks/keyngo_kioskm_deploy.yaml --ask-vault-pass --extra-vars="kioskm_devices=cen_kiosk1,cen_kiosk2 kioskm_version=3.03.001 kioskm_fetch=yes" 

### Ensure that all the required software is present in cen_kiosk1 and cen_kiosk2 and reboot the system, sending nexus artifacts from ansible server

ansible-playbook -i environments/keyngo_kioskm/main.yaml playbooks/keyngo_kioskm_prepare.yaml --ask-vault-pass --extra-vars="kioskm_devices=cen_kiosk1,cen_kiosk2 kioskm_reboot=yes kioskm_fetch=no" 
