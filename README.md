# roboshop-ansible (daws-92s)

Ansible playbooks for RoboShop v4, following https://github.com/daws-92s/roboshop-documentation

```shell
ansible-galaxy collection install -r requirements.yaml
ansible-playbook roboshop.yaml                    # create EC2 + Route53 records
ansible-playbook site.yaml                        # configure all servers in order
ansible-playbook 05-catalogue.yaml                # or one component
ansible-playbook roboshop.yaml -e action=delete   # tear down
```

Replace `daws92s.shop` with your domain in `inventory.ini`, `group_vars/all.yaml` and `roboshop.yaml`.
