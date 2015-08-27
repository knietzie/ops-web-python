Chef::Log.info("******Creating a data directory.******")

data_dir = value_for_platform(
  "amazon" => { "default" => "/srv/www" },
  "centos" => { "default" => "/srv/www" }
)

directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end


Chef::Log.info("******Installing container application******")
bash 'install' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    yum update 
    yum -y install httpd httpd-devel python python27-devel make git postgresql93 postgresql93-devel epel-release
    EOH
end

execute "install EPEL" do
    command "rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

execute "install python-pip" do
    command "yum -y install python-pip"
end

Chef::Log.info("******Copying from index.html from cookbook.******")
cookbook_file '/var/www/html/index.html' do
   source 'index.html'
   mode '0644'
end

Chef::Log.info("******Enable and start httpd.******")
service 'httpd' do
  action [ :enable, :start ]
end




# sudo git clone https://knietzie@bitbucket.org/imfree/ams.git#Deploy





