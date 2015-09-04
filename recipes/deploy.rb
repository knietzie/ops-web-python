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


# end
###-------------------###

#include_recipe "hello_app::webserver" 

deploy_revision node['ams']['deploy_dir'] do
  scm_provider Chef::Provider::Git 
  repo node['ams']['deploy_repo']
  revision node['ams']['deploy_branch']
  enable_submodules true
  shallow_clone false
  symlink_before_migrate({}) # Symlinks to add before running db migrations
  purge_before_symlink [] # Directories to delete before adding symlinks
  create_dirs_before_symlink ["config"] # Directories to create before adding symlinks
  ###symlinks({"config/local.config.php" => "config/local.config.php"})
  # migrate true
  # migration_command "php app/console doctrine:migrations:migrate" 
  action :deploy
  
  restart_command do
    service "httpd" do action :restart; end
  end
end


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