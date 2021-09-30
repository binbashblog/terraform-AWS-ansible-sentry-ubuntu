IMAGE_NAME = "bento/ubuntu-20.04"

Vagrant.configure("2") do |config|
    config.ssh.insert_key = true
    config.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 4
    end #end config.vm.provider

    config.vm.define "sentry-vm" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "sentry-vm"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "sentry-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.50.10",
            }
        end #end master.vm.provision
    end #end config.vm.define

end #end Vagrant.configure
