Chef::Log.info("******Creating deploymeny directory.******")
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
    yum -y install httpd httpd-devel python python27-devel make git gcc gcc-c++ postgresql93 postgresql93-devel epel-release
    EOH
end

# execute "install EPEL" do
#     command "rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
# end

execute "install EPEL" do
    command "rpm -qa | grep -qw  epel-release-6-8.noarch | rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
    # command "yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

execute "install python-pip" do
    command "yum -y install python-pip"
end

execute "install mod_wsgi" do
    command "yum -y install mod_wsgi"
end  

execute "Load mod_wsgi module" do
    command "echo 'LoadModule wsgi_module modules/mod_wsgi.so' > /etc/httpd/conf.d/wsgi.conf"
end    

# excute "setup httpd document root" do
# end

# execute "load module and restart apache" do
# end

# execute "wsgi.conf" do
#     command "echo 
#     'WSGIScriptAlias / /srv/www/ams/wsgi.py
#     WSGIPythonPath /srv/wwww/ams

#     <Directory /srv/www/ams>
#     <Files wsgi.py>
#     Require all granted
#     </Files>
#     </Directory>' > /etc/httpd/conf.d/wsgi.conf"
# end



Chef::Log.info("******Copying from index.html to replace standard http welcome pag.******")
cookbook_file '/var/www/html/index.py' do
   source 'index.py'
   mode '0644'
end

Chef::Log.info("******Enable and start httpd.******")
service 'httpd' do
  action [ :enable, :start ]
end




# sudo git clone https://knietzie@bitbucket.org/imfree/ams.git#Deploy





