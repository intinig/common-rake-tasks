require 'rubygems'
require 'vagrant'

namespace :vagrant do
  namespace :chef do
    desc "destroys vm and clean chef data from hosted chef"
    task :destroy do
      puts "destroying and removing chef info..."
      env = Vagrant::Environment.new
      node_name = env.config.for_vm(:default).keys[:vm].provisioners.first.config.node_name
      env.cli("destroy", "-f")
      system "knife node delete #{node_name} -y"
      system "knife client delete #{node_name} -y"
      puts "Finished destroying vm"
    end
  end
end
