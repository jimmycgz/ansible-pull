test:
	cd local-action-test && ansible-playbook -i inventory.ini local-actions.yaml -v

run:
	ansible-playbook -i inventory.ini local-actions.yaml -v	