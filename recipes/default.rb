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

bash 'update_and_install' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    #yum update 
    yum -y install httpd httpd-devel python python27-devel python-pip make git postgresql93 postgresql93-devel
    EOH

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





