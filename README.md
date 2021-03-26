# This code do it:
- call from jenkinsfile Terraform config file main.tf from GitHub and run it
- from Terraform config file main.tf create in GCP two instance - stage and prod whith Static IP
- Static IP add in inventory file for Ansible
- from Terraform config file call Ansible manifest file main.yml 


# Install Jenkins on host

sudo apt install openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

# Install Terraform on host

# Make Start Jenkins Service from root
sudo vi /etc/default/jenkins
$JENKINS_USER="root"
sudo chown -R root:root /var/lib/jenkins
sudo chown -R root:root /var/cache/jenkins
sudo chown -R root:root /var/log/jenkins
service jenkins restart ps -ef | grep jenkins

# In Web Jenkins 
# Install plug-in Terraform
# create new Job type Pipline
# 