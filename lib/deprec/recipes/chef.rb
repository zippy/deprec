# Copyright 2006-2009 by Mike Bailey. All rights reserved.
Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do 
    namespace :chef do
      
      set(:server_fqdn) { Capistrano::CLI.ui.ask 'Enter Chef server hostname' }
      set :recipes, 'chef::client'
      
      desc "Install Chef client"
      task :install do
        config
        # install_deps
        sudo 'chef-solo -c /etc/chef/solo.rb -j /etc/chef/chef.json -r http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz'
      end
      
      task :install_server do
        set :recipes, 'chef::recipes'
        install
      end
      
      # Install dependencies for Chef
      task :install_deps, :roles => :chef do
        top.deprec.couchdb.install
        # top.deprec.ruby.install # XXX can we put this back in?
        # apt.install( {:base => %w(ruby ruby1.8-dev libopenssl-ruby1.8 rdoc ri irb)}, :stable )
        top.deprec.ruby.install
        top.deprec.rubygems.install
        sudo "gem sources -a http://gems.opscode.com"
        sudo "gem install ohai chef --no-rdoc --no-ri"
      end
      
      SYSTEM_CONFIG_FILES[:chef] = [
        
        {:template => "solo.rb",
         :path => '/etc/chef/solo.rb',
         :mode => 0644,
         :owner => 'root:root'},
         
        {:template => "chef.json.erb",
         :path => '/etc/chef/chef.json',
         :mode => 0644,
         :owner => 'root:root'}
         
      ]
       
      desc "Generate Chef configs (system & project level)."
      task :config_gen do
        SYSTEM_CONFIG_FILES[:chef].each do |file|
          deprec2.render_template(:chef, file)
        end
      end

      desc "Push Chef config files (system & project level) to server"
      task :config, :roles => :chef do
        deprec2.push_configs(:chef, SYSTEM_CONFIG_FILES[:chef])
      end
      
      # desc "Set Chef to start on boot"
      # task :activate, :roles => :chef do
      #   send(run_method, "update-rc.d chef defaults")
      # end
      # 
      # desc "Set Chef to not start on boot"
      # task :deactivate, :roles => :chef do
      #   send(run_method, "update-rc.d -f chef remove")
      # end
      # 
      # desc "Start Chef"
      # task :start, :roles => :web do
      #   send(run_method, "/etc/init.d/chef start")
      # end
      # 
      # desc "Stop Chef"
      # task :stop, :roles => :web do
      #   send(run_method, "/etc/init.d/chef stop")
      # end
      # 
      # desc "Restart Chef"
      # task :restart, :roles => :web do
      #   send(run_method, "/etc/init.d/chef restart")
      # end
      # 
      # desc "Reload Chef"
      # task :reload, :roles => :web do
      #   send(run_method, "/etc/init.d/chef force-reload")
      # end
      
    end
    
  end
end
