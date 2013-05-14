# Copyright 2006-2008 by Mike Bailey. All rights reserved.
Capistrano::Configuration.instance(:must_exist).load do 

  namespace :deprec do
    namespace :mri do
            
      SRC_PACKAGES['ruby-1.8.7-p330'] = {
        :md5sum => "50a49edb787211598d08e756e733e42e  ruby-1.8.7-p330.tar.gz",
        :url => "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p330.tar.gz",
        :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline-gplv2-dev),
        :configure => "./configure --with-readline-dir=/usr/local;"
      }

      SRC_PACKAGES['ruby-1.9.2-p180'] = {
        :md5sum => "0d6953820c9918820dd916e79f4bfde8  ruby-1.9.2-p180.tar.gz", 
        :url => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz",
        :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline-gplv2-dev),
        :configure => "./configure",
        :post_install => 'sudo gem update --system'
      }

      SRC_PACKAGES['ruby-1.9.3-p194'] = {
        :md5sum => "bc0c715c69da4d1d8bd57069c19f6c0e  ruby-1.9.3-p194.tar.gz", 
        :url => "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz",
        :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline-gplv2-dev libyaml-dev),
        :configure => "./configure",
        :post_install => 'sudo gem update --system'
      }

      SRC_PACKAGES['ruby-2.0.0-p0'] = {
        :md5sum => "db5af5d6034646ad194cbdf6e50f49ee  ruby-2.0.0-p0.tar.gz", 
        :url => "http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.gz",
        :deps => %w(zlib1g-dev libssl-dev libncurses5-dev libreadline-gplv2-dev libyaml-dev),
        :configure => "./configure",
        :post_install => 'sudo gem update --system'
      }


      src_package_options = SRC_PACKAGES.keys.select{|k| k.match /^ruby-\d\.\d\.\d/ }
      set(:mri_src_package) { 
        puts "Select mri_src_package from list:"
        Capistrano::CLI.ui.choose do |menu|
          menu.choices(*src_package_options)
        end
      }

      desc "Install Ruby"
      task :install do
        deprec2.download_src(SRC_PACKAGES[mri_src_package])
        deprec2.install_from_src(SRC_PACKAGES[mri_src_package])
      end
      
    end
  end
  
end
