ANSIBLE SYSDEV REPOSITORY

Way of working of this repo: https://rentalcar.sharepoint.com/:w:/s/it/it_smo/ESMDkkUusiJFpBPAXl-1jZsBbKGE1AOaW8SpUogbjsp7CQ?e=Hux7E7


Install local DEV environment:

	- Install cygwin following guide: https://rentalcar.sharepoint.com/:w:/s/it/it_pmo/EQxIfs67-4lKsDeWwntwYpoBjINn98lkOLeeKzph_TG46w?rtime=G7CnRdHz1kg

	- Install software dependencies:
		- Virtual Box - Version 6.0.8 r130520
		- VirtualBox extension pack - 6.0.8
		- Vagrant - Version 2.2.4
		- Packer - Version 1.4.1 (W64)
		- ansible 2.8.0

Preparation tasks:
	 
	1.- Copy ssh-config/config file from the repo (which contains our local environment) to ~/.ssh/ (TODO Automate this step)
	2.- Create a file  ~/.vault_pass.txt which contains ansible vault encryption key (Vault Ansible in PMP).

Work using Vagrant:

	- List vagrant vms available - vagrant status 
	
		Current machine states:

		ubu.rentalcar.local         running (virtualbox)
		rhel.rentalcar.local        running (virtualbox)

	- Boot new machine:
		
		vagrant up ubu.rentalcar.local

	- Connect to recently created machine: 
		
		ssh ubu.rentalcar.local  (*id_rsa must be created previously an located under ~/.ssh/)

	- Destroy vm:
		
		vagrant destroy ubu.rentalcar.local

Test Ansible by environment:
	
	LOCAL:
		Linux:		ansible --vault-password-file ~/.vault_pass.txt ubuntu -u vagrant -i environments/local/ -m ping

	NON-PROD:

		Linux:   	ansible --vault-password-file ~/.vault_pass.txt <group> -i environments/non-prod-env/ -m ping
		Windows:        ansible --vault-password-file ~/.vault_pass.txt <group> -i environments/non-prod-env/ -m win_ping
	PROD: 
		Linux:          ansible --ask-vault-pass <group> -i environments/production/ -m ping
                Windows:        ansible --ask-vault-pass <group> -i environments/production/ -m win_ping
	

