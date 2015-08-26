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
  user: sudo
  action :install
end

package 'httpd-devel' do
  user: sudo
  action :install
end

Chef::Log.info("******Enable and start httpd.******")
service 'httpd' do
  user: sudo
  action [ :enable, :start ]
end

Chef::Log.info("******Copying from index.html from cookbook.******")
cookbook_file '/var/www/html/index.html' do
   source 'index.html'
   mode '0644'
end

package "python27" do
  user: sudo
  action :install
end

package "python27-devel" do
  user: sudo
  action :install
end

package "gcc" do
  user: sudo
  action :install
end


package "gcc-c++" do
  user: sudo
  action :install
end

package "subversion" do
  user: sudo
  action :install
end

package "make" do
  user: sudo
  action :install
end

package "uuid" do
  user: sudo
  action :install
end

package "libuuid-devel" do
  user: sudo
  action :install
end

package "python-devel" do
  user: sudo
  action :install
end

package "python27-devel" do
  user: sudo
  action :install
end

package "make" do
  user: sudo
  action :install
end

package "postgresql93" do
  user: sudo
  action :install
end

package "postgresql93-devel" do
  user: sudo
  action :install
end

#yum install python27 python27-devel gcc gcc-c++ subversion git httpd make uuid libuuid-devel
#yum install httpd-devel
#ams apps requirements
#yum install python-devel python27-devel nginx git make postgresql93 postgresql93-devel
#yum install python27 python27-devel gcc gcc-c++ subversion git httpd make uuid libuuid-devel
#yum install httpd-devel


