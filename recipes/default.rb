Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "amazon" => { "default" => "/srv/www/shared" },
  "ubuntu" => { "default" => "/srv/www/data" },
  "default" => "/srv/www/config"
)

directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end

Chef::Log.info("******Installing apache (httpd).******")
package 'httpd' do
  action :install
end

Chef::Log.info("******Enable and start httpd.******")
service 'httpd' do
  action [ :enable, :start ]
end

Chef::Log.info("******Copying from index.html from cookbook.******")
cookbook_file '/var/www/html/index.html' do
   source 'index.html'
   mode '0644'
end
