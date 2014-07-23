# -*- mode: ruby -*-
# vi: set ft=ruby :

$ruby_work = <<SCRIPT
# Install RVM, ruby 2.0, and the librarian-puppet gem
ruby --version 2>&1 | grep -q 2.0.0
if [ "$?" != "0" ]; then
    echo "Installing rvm, ruby, and librarian-puppet"
    curl -sSL https://get.rvm.io | bash -s -- --ruby=2.0.0 --gems=librarian-puppet,puppet
fi

source /usr/local/rvm/scripts/rvm
cd /vagrant
# Pull down the required puppet modules
if [ -f Puppetfile.lock ]; then
    librarian-puppet update --verbose
else
    librarian-puppet install --verbose --path puppet/modules
fi
SCRIPT

$start_captain = <<SCRIPT
set -x
sudo -u vagrant screen -ls | grep captain
if [ $? -eq 1 ]; then
    echo "Starting new captain screen session..."
    cd /vagrant
    sudo -u vagrant screen -dmS captain sh -c 'python manage.py runserver 0.0.0.0:8000; exec bash'
fi
SCRIPT

$start_shove = <<SCRIPT
set -x
sudo -u vagrant screen -ls | grep shove
if [ $? -eq 1 ]; then
    echo "Starting new shove screen session..."
    cd /vagrant
    sudo -u vagrant screen -dmS shove sh -c 'shove; exec bash'
fi
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  manifests_path = "./puppet/manifests"
  module_path = "./puppet/modules"
  manifest_file = "vagrant.pp"

  box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  # See https://github.com/mitchellh/vagrant/issues/1172#issuecomment-42263664 for motivation
  fix_dns_fragment = "if [ ! $(grep single-request-reopen /etc/sysconfig/network) ]; then echo RES_OPTIONS=single-request-reopen >> /etc/sysconfig/network && service network restart; fi"


  config.vm.define "captain" do |conf|
    conf.vm.box = "CentOS 6.5 x86_64"
    conf.vm.hostname = "captain"
    conf.vm.box_url = box_url
    # NOTE: If you update captain's ip make sure to update it in puppet/manifests/vagrant.pp
    conf.vm.network "private_network", ip: "192.168.238.77"
    conf.vm.network "forwarded_port", guest: 8000, host: 8000
    conf.vm.provision "shell", inline: fix_dns_fragment
    conf.vm.provision "shell", inline: $ruby_work
    conf.vm.provision :puppet do |puppet|
        puppet.manifests_path = manifests_path
        puppet.module_path = module_path
        puppet.manifest_file = manifest_file
    end
    conf.vm.provision "shell", inline: $start_captain
  end

  config.vm.define "shove" do |conf|
    conf.vm.box = "CentOS 6.5 x86_64"
    conf.vm.hostname = "shove"
    conf.vm.box_url = box_url
    conf.vm.network "private_network", ip: "192.168.238.78"
    conf.vm.provision "shell", inline: fix_dns_fragment
    conf.vm.provision "shell", inline: $ruby_work
    conf.vm.provision :puppet do |puppet|
        puppet.manifests_path = manifests_path
        puppet.module_path = module_path
        puppet.manifest_file = manifest_file
    end
    conf.vm.provision "shell", inline: $start_shove
  end
end
