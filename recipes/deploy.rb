include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')
  webapp_dir = ::File.join(node['tomcat']['webapps_base_dir'], deploy[:document_root].blank? ? application : deploy[:document_root])

  # opsworks_deploy creates some stub dirs, which are not needed for typical webapps
  ruby_block "remove unnecessary directory entries in #{current_dir}" do
    block do
      node['tomcat']['webapps_dir_entries_to_delete'].each do |dir_entry|
        ::FileUtils.rm_rf(::File.join(current_dir, dir_entry), :secure => true)
      end
    end
  end

  link webapp_dir do
    to current_dir
    action :create
  end

  #include_recipe 'tomcat::service'

  #execute 'trigger tomcat service restart' do
  #  command '/bin/true'
#     not_if { node['tomcat']['auto_deploy'].to_s == 'true' }
#     notifies :restart, resources(:service => 'tomcat')
#   end
# end

# include_recipe 'tomcat::context'
