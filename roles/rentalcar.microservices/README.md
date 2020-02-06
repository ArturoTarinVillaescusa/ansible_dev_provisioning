### MICROSERVICES ROLE ### 
### This role has been created in order to deploy each current microservice in windows machines as a service.
###
### VARS:

### List of vars related: All of them must be added under group_vars folder using its microservice's name (eg.- mssconnectedcars.yml)

mss_app_version: Version of microservice
mss_app_user: Service used
mss_app_userpass: Password of service user
mss_db_server: DB Host
mss_db_name: DB Name
mss_db_user: DB user
mss_db_pass: DB user password
mss_port: Por used by the microservice
mss_java_artifact: jre-8u91-windows-i586.exe
mss_app_artifact: MSSConnectedCars
mss_app_auth_env: integ

#Scheduler data
mss_connectedcars_third_host: http://localhost
mss_connectedcars_third_port: 18001

## COMMON VARS

mss_properties_file: <microservice_name>.application.properties"
mss_installation_global_folder: "C:\\Microservices\\"
mss_artifact_name: "<microservice_name>-<microservice_version>"
mss_scheduler_url: "http://localhost:9010/Scheduler"

### HOW TO Deploy Microservices:

Lab environment:

	ansible-playbook --vault-password-file ~/.vault_pass.txt playbooks/clickandgo.yml -i environments/lab/ --extra-vars="hosts=mssconnectedcars mss_name=mssconnectedcars mss_version=3.0.0-SNAPSHOT"

PROD environment:
	
	ansible-playbook --ask-vault-pass playbooks/clickandgo.yml -i environments/production --extra-vars="hosts=mssconnectedcars mss_name=mssconnectedcars mss_version=3.0.0"


- Where: 
	- .vault_pass.txt contains environment valt related password.
	- environments/lab/ points to lab environment.
	- Hosts=mssconnectedcars, is calling mssconnectedcars group_vars environment file.
