$script = <<-'SCRIPT'

# Upgrade all packages
apt-get update
apt-get upgrade

# Remove docker conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Install docker certificate
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add docker mirror
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add jenkins mirror
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install dependencies
apt-get update
apt-get -y --autoremove install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin default-jre jenkins

# Postinstall for docker
groupadd docker
usermod -aG docker $USER
usermod -aG docker jenkins
newgrp docker

# Enable vim
echo "set -o vi" >> /home/vagrant/.bashrc
echo "export VISUAL=vim" >> /home/vagrant/.bashrc
echo "export EDITOR="$VISUAL"" >> /home/vagrant/.bashrc

# Start jenkins
systemctl enable jenkins
systemctl start jenkins

# Fix issue where it says jenkins is offline
sed -i -e 's/https/http/g' /var/lib/jenkins/hudson.model.UpdateCenter.xml
systemctl restart jenkins

# Echo jenkins password
# echo "Visit http://192.168.56.20:8080 and enter password below to begin"
cat /var/lib/jenkins/secrets/initialAdminPassword

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |v|
    v.cpus = 8
    v.memory = 8192
    v.gui = false
  end
  config.vm.synced_folder '~/ntech', '/ntech'

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = 'alvistack/ubuntu-24.04'
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.network "private_network", ip: "192.168.56.20"
    jenkins.vm.network :forwarded_port, guest: 443, host: 9002
    jenkins.vm.provision "shell", inline: $script
  end
end
