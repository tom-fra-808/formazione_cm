
Vagrant.configure("2") do |config|
  config.vm.define "registry" do |registry|
    registry.vm.box = "bento/debian-12"
    registry.vm.hostname = "docker-registry"
    registry.vm.network "private_network", ip: "192.168.58.10"

    registry.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end
end
