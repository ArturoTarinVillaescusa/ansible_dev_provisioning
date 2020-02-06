### SAR - Deploy SIS
### This role has been created to deploy SAR component called SIS which is in charge of balance requests from brokers to another daemons like CDV, TAR, PRI, send logs etc.
###
### VARS:

### List of vars related:

'sar_sis_service_user: Service user'  
'sar_sis_service_user_password: Service user password'  
'sar_sis_service_port: Port'  
'sar_sis_db_server: DB server'  
'sar_sis_db_name: DB instance'  
'sar_sis_artifact_name: Artifact executable'  
'sar_sis_properties_file: Propeties file '  
'sar_sis_db_ini: DB properties file'  
'sar_sis_data_ini: Data ini file'  
'sar_sis_nexus_url: Artifact nexus repository'  
'sar_sis_installation_folder: Installation folder'  
'sar_sis_certs_folder: Certificates folder'  
'sar_sis_logs_folder: Logs folder'  
'sar_sis_esquemas_folder: Private schemas'  
'sar_sis_launch_file: Launch file'  
'sar_sis_log_server: Log shipping server'  

### HOW TO Deploy SIS:

Lab environment:

	ansible-playbook --vault-password-file ~/.vault_pass.txt playbooks/sarsis_deploy.yml -i environments/lab/ --extra-vars="hosts=SIS sar_sis_version=4.10.000-6349338"

PROD environment:
	
	ansible-playbook --ask-vault-pass playbooks/sarsis_deploy.yml -i environments/production --extra-vars="hosts=SIS_<ENV> sar_sis_version=4.10.000-6349338"


- Where: 
	- .vault_pass.txt contains environment valt related password.
	- environments/lab/ points to lab environment.
	- Hosts=SAR, is calling SAR group_vars environment file.
	- sar_sis_version extra var, has SIS version.
