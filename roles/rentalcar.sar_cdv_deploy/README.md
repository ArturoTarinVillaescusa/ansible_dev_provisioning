### SAR - Deploy CDV
### This role has been created to deploy SAR component called CDV which is in charge of calculate vehicles availability
###
### VARS:

### List of vars related:

### SAR CDV ###
'sar_cdv_service_user: Service user'  
'sar_cdv_service_user_password: Service user password'  
'sar_cdv_service_port: Port'  
'sar_cdv_db_server: DB server'  
'sar_cdv_db_name: DB instance'  
'sar_cdv_artifact_name: Artifact executable'  
'sar_cdv_properties_file: Propeties file '  
'sar_cdv_data_ini: Data ini file'  
'sar_cdv_nexus_url: Artifact nexus repository'  
'sar_cdv_installation_folder: Installation folder'  
'sar_cdv_launch_file: Launch file'  
'sar_cdv_log_server: Log shipping server'  

### HOW TO Deploy CDV:

Lab environment:

	ansible-playbook --vault-password-file ~/.vault_pass.txt playbooks/sar_cdv_deploy.yml -i environments/lab/ --extra-vars="hosts=SAR sar_cdv_version=4.02.001-dd175bb"


PROD environment:

        ansible-playbook --ask-vault-pass playbooks/sar_cdv_deploy.yml -i environments/production --extra-vars="hosts=CDV_<ENV> sar_sis_version=4.02.001-dd175bb"

- Where: 
	- .vault_pass.txt contains environment valt related password.
	- environments/lab/ points to lab environment.
	- Hosts=SAR, is calling SAR group_vars environment file.
	- sar_cdv_version extra var, has cdv version.
