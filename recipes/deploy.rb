# git "ams" do
#   repository "git@bitbucket.org:imfree/ams.git"
#   revision "testing"
#   action :sync
#   destination "/srv/www/shared"
#   user "root"

#   # add id_rsa (private)
#   # test bitbucket conn  ssh -Tv git@bitbucket.org
#   # git ls-remote "git@bitbucket.org:imfree/ams.git" testing
#   # sudo opsworks-agent-cli run_command
#   #ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"
#   # deploy wrapper http://stackoverflow.com/questions/18388722/chef-deploy-resource-private-repo-ssh-deploy-keys-and-ssh-wrapper
#   #http://www.jasongrimes.org/2012/06/deploying-a-lamp-application-with-chef-vagrant-and-ec2-3-of-3/#private-repo
#    still on data bag http://engineering.ooyala.com/blog/keeping-secrets-chef
# http://atomic-penguin.github.io/blog/2013/06/07/HOWTO-test-kitchen-and-encrypted-data-bags/

# end
###-------------------###


#Recipe to get id_ss

Chef::Log.info("****** Deploying AMS to /srv/www ******") 
deploy 'ams' do
  repo 'git@bitbucket.org:imfree/ams.git'
  revision 'master'
  user 'root'
  deploy_to '/srv/www'
  symlink_before_migrate({})
  purge_before_symlink []
  #ssh_keypair node['ams']['keypair']
  ssh_wrapper '/root/.ssh/wrap-ssh4git.sh' 
  action :deploy
end

# Master Branch:
# RDS: aaidybs26rgr4c.cjkpdonajlva.ap-southeast-1.rds.amazonaws.com 

## ----- ams deloy attributes
           # deploy("ams") do
           #   action [:deploy]
           #   retries 0
           #   retry_delay 2
           #   default_guard_interpreter :default
           #   deploy_to "/srv/www"
           #   repository_cache "cached-copy"
           #   create_dirs_before_symlink ["tmp", "public", "config"]
           #   symlinks {"system"=>"public/system", "pids"=>"tmp/pids", "log"=>"log"}
           #   revision "testing"
           #   remote "origin"
           #   scm_provider Chef::Provider::Git
           #   keep_releases 5
           #   enable_checkout true
           #   checkout_branch "deploy"
           #   declared_type :deploy
           #   cookbook_name :"ops-web-python"
           #   recipe_name "deploy"
           #   repo "git@bitbucket.org:imfree/ams.git"
           #   user "root"
           #   git_ssh_wrapper "/root/.ssh/wrap-ssh4git.sh"
           #   shared_path "/srv/www/shared"
           #   destination "/srv/www/shared/cached-copy"
           #   current_path "/srv/www/current"
           # end
#

Chef::Log.info("****** Run requirements.txt to ******") 
bash 'Update requirements and deploy collect static' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www
    #virtualenv venv
    source venv/bin/activate
    venv/bin/pip install --upgrade pip
    venv/bin/pip install -r current/requirements.txt
    mkdir /srv/www/current/static
    cd /srv/www/current/static
    ../manage.py collectstatic -v0 --noinput
  EOH
end


Chef::Log.info("****** Run gunicorn ******") 
# #runs staticcollecy
#https://docs.djangoproject.com/en/dev/howto/static-files/deployment/
# ./manage.py collectstatic -v0 --noinput'


#setup virtual environemnt (/srv/wwww/venv)
# [2015-09-05 17:32:52 +0000] [5166] [INFO] Shutting down: Master
# (venv)[root@default-centos-65 current]# pwd
# /srv/www/current
# (venv)[root@default-centos-65 current]# gunicorn ams.wsgi:application

# (venv)[root@default-centos-65 www]# cd current/
# (venv)[root@default-centos-65 current]# gunicorn -w3 ams.wsgi:application

# [vagrant@default-centos-65 ~]$ ps -ef  |grep gunicorn
# root      1579  1500  0 01:45 pts/0    00:00:00 /srv/www/venv/bin/python /srv/www/venv/bin/gunicorn ams.wsgi:application
# root      1584  1579  0 01:45 pts/0    00:00:00 /srv/www/venv/bin/python /srv/www/venv/bin/gunicorn ams.wsgi:application
# vagrant   1623  1603  0 01:46 pts/2    00:00:00 grep gunicorn

bash 'Run gunicorn' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www/
    source venv/bin/activate
    cd /srv/www/current
    gunicorn -w3 ams.wsgi:application 
  EOH
end



# Chef::Log.info(" ****** Re-start Httpd ****** ")
# service 'httpd' do
#   action [ :enable, :restop ]
# end

#Deployment - http://bicofino.io/blog/2014/01/16/installing-python-2-dot-7-6-on-centos-6-dot-5/
# Deployment - http://www.slideshare.net/jweiss/chefconf-2014-aws-opsworks-under-the-hood

# Chef::Log.info("****** Runserver (python) ******") 
# bash 'activate_virtualenv' do
#   user "root"
#   cwd "/tmp" 
#   code <<-EOH
#     cd /srv/www
#     virtualenv venv
#     source venv/bin/activate
#     venv/bin/python current/manage.py runnserver 0.0.0.0:80
#   EOH
# end

# deploy_revision node['ams']['deploy_dir'] do
#   scm_provider Chef::Provider::Git 
#   repo node['ams']['deploy_repo']
#   revision node['ams']['deploy_branch']
#   key_pair node['ams']['keypair']
#   enable_submodules true
#   shallow_clone false
#   symlink_before_migrate({}) # Symlinks to add before running db migrations
#   purge_before_symlink [] # Directories to delete before adding symlinks
#   create_dirs_before_symlink ["config"] # Directories to create before adding symlinks
#   ###symlinks({"config/local.config.php" => "config/local.config.php"})
#   # migrate true
#   # migration_command "php app/console doctrine:migrations:migrate" 
#   action :deploy

#   restart_command do
#     service "httpd" do action :restart; end
#   end
# end


# deploy "#{node[:app][:dir]}" do 
#     repo "#{node[:app][:repo]}"
#     revision "#{node[:app][:branch]}"
#     user "opsdeploy"


# end    
#     #owner "deploy




# # #----
# # deploy "#{node[:app][:dir]}" do
# #     repo "#{node[:app][:repo]}"
# #     revision "#{node[:app][:branch]}"
# #     user "deploy"
# #     #owner "deploy
# #     purge_before_symlink %w{tmp log}
# #     create_dirs_before_symlink ["tmp"]
# #     symlink_before_migrate "system/database.js" => "config/database-sim.js"
# #     symlinks "pids"=>"tmp/pids", "log"=>"log"
  
# #     before_restart do
# #         current_release = release_path
 
# #         bash "npminstall" do
# #             user "deploy"
# #             cwd "#{current_release}"
# #             code <<-EOH
            
# #             cp -f #{node[:app][:dir]}/shared/system/database.yml #{current_release}/config/database.yml
# #             cp -f #{node[:app][:dir]}/shared/system/server.yml #{current_release}/config/server.yml
# #             cp -f #{node[:app][:dir]}/shared/system/permissions.yml #{current_release}/config/permissions.yml
# #             cp -f #{node[:app][:dir]}/shared/system/s3config.yml #{current_release}/config/s3config.yml
# #             cp -f #{node[:app][:dir]}/shared/system/node_modules.tgz #{current_release}/node_modules.tgz
# #             # /home/deploy/nvm/v0.11.1/bin/npm install
# #             tar -xzvf node_modules.tgz
# #                                 EOH
# #             environment 'HOME' => "#{current_release}"
# #         end
       
 
#         bash "bundle" do
#             user "root"
#             cwd "#{current_release}"
#             code <<-EOH
            
#             chown -R deploy:deploy #{node[:app][:dir]}
#             chown -R deploy:deploy /mnt/#{node[:app][:mynamespace]}-log
#             EOH
#         end
#     end
 
#         migrate false
#         action :deploy # or :rollback
#         #restart_command "touch tmp/restart.txt"
#         git_ssh_wrapper "/home/deploy/.ssh/wrap-ssh4git.sh"
#                 #scm_provider Chef::Provider::Git # is the default, for svn: Chef::Provider::Subversion
# end