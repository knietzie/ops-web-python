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
end

package 'httpd-devel' do
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
end

package "python27-devel" do
end

package "gcc" do
end

package "gcc-c++" do
end

package "subversion" do
end

package "make" do
end

package "uuid" do
end

package "libuuid-devel" do
end

package "python-devel" do
end

package "python27-devel" do
end

package "make" do
end

package "postgresql93" do
end

package "postgresql93-devel" do
end

