# TP2 : Déploiement automatisé
## I. Déploiement simple
```
 ~/Vagrant/centos_TP1  cat Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

disk = './disk2.vdi'
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.define "node0"

  config.vbguest.auto_update = false
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.hostname = "node0"
  config.vm.network "private_network", ip: "192.168.100.11"

  config.vm.provider "virtualbox" do |vb|
    unless File.exist?(disk)
      vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 5 * 1024]
    end
    
    vb.memory = 1024
    vb.name = "centos_vagrant_TP2"
    vb.customize ['storageattach', :id,  '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
  end

  config.vm.provision "shell", path: "install_vim.sh"
end


~/Vagrant/centos_TP1  cat install_vim.sh
sudo yum install -y vim
```

# II. Re-package
```
vagrant@node0 ~]$ history
    1  sudo yum update
    2  sudo yum install vim
    3  sudo yum install epel-release
    4  sudo yum install nginx
    5  sudo setenforce 0
    6  sudo vim /etc/selinux/config
    7  sestatus
    8  sudo systemctl start firewalld
    9  sudo firewall-cmd --add-port=22/tcp --permanent
   10  sudo firewall-cmd --reload
```

```
~/Vagrant/centos_TP2_II  vagrant package --output b2-tp2-centos.box
~/Vagrant/centos_TP2_II  vagrant box add B2TP2/centos7 b2-tp2-centos.box
```

# III. Multi-node deployment
```
~/Vagrant/centos_TP2_III  cat Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "B2TP2/centos7"

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.network "private_network", ip: "192.168.2.21"
    node1.vm.provider "virtualbox" do |vb|
      vb.name = "b2.tp2.node1"
      vb.memory = "1024"
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
    node2.vm.network "private_network", ip: "192.168.2.22"
    node2.vm.provider "virtualbox" do |vb|
      vb.name = "b2.tp2.node2"
      vb.memory = "512"
    end
  end
end
```

# IV. Automation here we (slowly) come