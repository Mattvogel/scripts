ansible-galaxy install geerlingguy.postgresql lae.netbox
ansible-playbook -i $1, ~/.ansible/roles/lae.netbox/examples/playbook_single_host_deploy.yml -K -u $2
