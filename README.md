# ansible-pull make configuration management more flexible
Best practice for a very typical use case: how to manage various workstations(dinamica ips, multiple oses, can't ssh)? Try ansible-pull mode

## Use Case 1:

I'm hosting multiple applications by several scaling groups load balancing for front-end layer, application layer and DB layer. The IPs get changed each time scaling up happendes on each scaling group. How I can efficient deploy the latest artifact with updated configuration to each server? How to make everything immutable?

## Use Case 2:

My company has one old application running in 300 workstations including Windows 98, SE, 7, Suse , Redhat, Cenos and Ubuntu, but it's not allowed to open port 22 so that we can't simply using Ansible to push the artifact by SSH connections. How can we effectively deploy the code multiple times a week?

## Solution: try ansible-pull at server localhost
Have a centralized git repo storing all latest code with updated ansible configuration code, use ansible-pull at each node just once, it'll automatically setup cron job in each node to check the repo update every 10 minutes (by using ansible-pull with -o parameter), it does nothing if there's no any code change on the repo, and it downloads the latest code if have changes, to the target (local host) node and update the workload automatically. The admin needs only update the configuration code or application code to the repo.

Got inspired from Jay's series post as below links:
https://opensource.com/article/18/3/manage-workstation-ansible
https://opensource.com/article/18/3/manage-your-workstation-configuration-ansible-part-2

* Step 0: Create this repo, create this readme file, and all other files and folders.
> File local.yml: refresh apt repositories like CLI "sudo apt update" and invoke another 3 yml files, 
> tasks/packages.yml: install 3 appliations on the local host node (htop,mc,tmux).
> tasks/users.yml: create ansible user with sudo previlege,copy sudoers from files folder.
> tasks/cron.yml: create cronb job in user ansible, check the update of central repo every 10minutes, pull the latest version if have any changes or do nothing.

* Step 1 (DONE): Launch a new ec2 ubuntu 16.04 as one of the target servers, may bake it when finish initial setup, or put the code to user data of Launch Template.
* Step 2 (DONE): Install ansible on the node. Below lines will also install Python 2.7.12 as default.

```
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
python --version
git --version
git version 2.7.4
```

* Step 3 (DONE): Apply the playbook by pulling command. The 3 applications will be installed on the server node.

```
sudo ansible-pull -U https://github.com/jimmycgz/ansible-pull.git
```

## Further Steps
* Step4 (Todo): bake or setup user data
* Step5: Use docker container to host applications and test pull deployment

