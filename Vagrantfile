Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |v|
    v.cpus = 8
    v.memory = 8192
    v.gui = false
  end

  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_ed25519.pub").first.strip
    s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      echo "set -o vi" >> /home/vagrant/.bashrc
      echo "set -o vi" >> /root/.bashrc
      echo "export VISUAL=vim" >> /home/vagrant/.bashrc
      echo "export VISUAL=vim" >> /root/.bashrc
      echo "export EDITOR=vim" >> /home/vagrant/.bashrc
      echo "export EDITOR=vim" >> /root/.bashrc
    SHELL
  end

  config.vm.define "jenkins" do |jenkins|
    jenkins.vm.box = 'alvistack/ubuntu-24.04'
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.network "private_network", ip: "192.168.56.20"
    jenkins.vm.network :forwarded_port, guest: 443, host: 9002
  end
end
