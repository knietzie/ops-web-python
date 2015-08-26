Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "amazon" => { "default" => "/srv/www/shared" },
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

package 'httpd-devel' do
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

package "python27" do
  action :install
end

package "python27-devel" do
  action :install
end

package "gcc" do
  action :install
end


package "gcc-c++" do
  action :install
end

package "subversion" do
  action :install
end

package "make" do
  action :install
end

package "uuid" do
  action :install
end

package "libuuid-devel" do
  action :install
end

package "python-devel" do
  action :install
end

package "python27-devel" do
  action :install
end

package "make" do
  action :install
end

package "postgresql93" do
  action :install
end

package "postgresql93-devel" do
  action :install
end

