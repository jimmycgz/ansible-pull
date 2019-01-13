# ansible-pull make configuration management more flexible
Best practice for a very typical use case: how to manage various workstations(dinamica ips, multiple oses, can't ssh)? Try ansible-pull mode

## Use Case:

I'm hosting multiple applications by several scaling groups load balancing for front-end layer, application layer and DB layer. The IPs get changed each time scaling up happendes on each scaling group. How I can efficient deploy the latest artifact with updated configuration to each server? How to make everything immutable?


## Solution: try ansible-pull at server localhost
Have a centralized git reop storing all latest code with updated ansible configuration code, setup cron job in each node (may bake in AMI) to run ansible-pull every 10 minutes with -o parameter, it doesn't nothing if there's no any code change on the repo, and it downloads the latest code if have changes, to the target (local host) node and update the workload automatically. The admin needs only update the configuration code or application code to the repo.

Got inspired from Jay's series post as below links:
https://opensource.com/article/18/3/manage-workstation-ansible
https://opensource.com/article/18/3/manage-your-workstation-configuration-ansible-part-2

* Step0: Creaet this repo, create this readme file and local.yml
```
- hosts: localhost
  become: true
  tasks:
  - name: ['htop', 'mc', 'tmux']
```

* Step1: Launch a new ec2 ubuntu 16.04 as one of the target servers (say, from Launch Configuration: Jmy-launch-config-V4, may bake it when finish initial setup, or put the code to user data of Launch Template.
* Step2: Install ansible on the node, with python and git.
```
python --version
Python 2.7.12
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
git --version
git version 2.7.4
```

* Step3: 
```
sudo ansible-pull -U https://github.com/jimmycgz/ansible-pull.git
```
git clone and initi cron job.
* Step4: bake or setup user data
* Step5: Use docker container to host applications and test pull deployment
