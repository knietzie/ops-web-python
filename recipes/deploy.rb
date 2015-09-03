git "ams" do
  repository "git@bitbucket.org:imfree/ams.git"
  revision "testing"
  action :sync
  destination "/srv/www/shared"
  user "root"
  #ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"
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