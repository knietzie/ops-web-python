Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "amazon" => { "default" => "/srv/www/shared" },
  "centos" => { "default" => "/srv/www/shared" }
)

directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end

# Chef::Log.info("******Copying from index.html from cookbook.******")
# cookbook_file '/var/www/html/index.html' do
#    source 'index.html'
#    mode '0644'
# end

bash 'update_and_install' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    #yum update -y
    yum install -y  httpd httpd-devel
    #yum install httpd httpd-devel python27 python27-devel gcc gcc-c++ subversion git httpd make uuid libuuid -devel install httpd-devel python-devel python27-devel nginx git make postgresql93 postgresql93-devel
    EOH
end

# Chef::Log.info("******Enable and start httpd.******")
# service 'httpd' do
#   action [ :enable, :start ]
# end

