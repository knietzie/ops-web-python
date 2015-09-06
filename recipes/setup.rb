Chef::Log.info("****** Setup deployment directory ******")
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


Chef::Log.info("****** Installing container applications ******")
bash 'install' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    #yum update 
    yum -y install httpd httpd-devel python python-devel python27-devel make git gcc gcc-c++ uuid libuuid-devel mysql-devel postgresql93 postgresql93-devel postgresql-devel
    EOH
end

# Chef::Log.info("****** Python 2.7 from tarball ******")
# bash 'install' do
#   user "root"
#   cwd "/tmp" 
#   code <<-EOH   
#     wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz
#     tar xvfz Python-2.7.8.tgz
#     cd Python-2.7.8
#     ./configure --prefix=/usr/local
#     make 
#     make altinstall
#     EOH
# end

# execute "install EPEL" do
#     command "rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
# end

execute "install_EPEL" do
    command "rpm -qa | grep -qw  epel-release-6-8.noarch | rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
    # command "yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end

execute "install_python-pip" do
    command "yum -y install python-pip"
end

# Gaining Access to SCLs
# https://wiki.centos.org/AdditionalResources/Repositories/SCL
execute "install_SCL" do
    command "yum -y install python27"
end

execute "install_mod_wsgi" do
    command "yum -y install mod_wsgi"
end  

execute "Load_mod_wsgi module" do
    command "echo 'LoadModule wsgi_module modules/mod_wsgi.so' > /etc/httpd/conf.d/wsgi.conf"
end    

#Use WSGI.conf.erb template
template "/etc/httpd/conf.d/wsgi.conf" do
  source "wsgi.conf.erb"
end


# execute "wsgi.conf" do
#      command "echo 
#      'WSGIScriptAlias / /srv/www/current/ams/wsgi.py
#      WSGIPythonPath /srv/wwww/current

#      <Directory /srv/www/current>
#      <Files wsgi.py>
#      Require all granted#
#       </Files>
#      </Directory>' > /etc/httpd/conf.d/wsgi.conf"
#  end



# Chef::Log.info("******Copying from index.html to replace standard http welcome pag.******")
# cookbook_file '/var/www/html/index.py' do
#    source 'index.py'
#    mode '0644'
# end

Chef::Log.info("****** Start Httpd ******")
service 'httpd' do
  action [ :enable, :start ]
end

# Install virtualenv via Pip
# virtualenv venv
# source venv/bin/activate
#

execute "install_package" do
    command "sudo pip install virtualenv"
end  

#setup virtual environemnt (/srv/wwww/venv)
bash 'activate_virtualenv' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www
    virtualenv venv
    source venv/bin/activate
    #venv/bin/pip install -r current/requirements.txt
  EOH
end

# # Install python2.7 via venv
# bash 'install_python2.7' do
#   user "root"
#   cwd "/tmp"
#   code <<-EOH
#     /srv/www/venv/bin/easy_install install python2.7
#   EOH
# end 


Chef::Log.info("****** --------------- Start of Deployment -----------------******")


# Initial deploy
bash 'deploy' do
  user "root"
  cwd "/tmp"
  code <<-EOH
    /srv/www/venv/bin/easy_install install python2.7
  EOH
end 


Chef::Log.info("****** --------------- Pull From Repo -----------------******")
# - Pull from repo
# - Set symnlinks
#   git clone -b develop git@github.com:user/myproject.git

#
# After pullout, go to virtualenv
# Install requirements.txt
# Restart httpd


# execute "Python2.7 install Python2.7" do
#     command "sudo /srv/www/venv/bin/easy_install install python2.7"
# end  

# Notes on installing python, it should be 2.7 to avoid compatibility inssues
# http://tuxlabs.com/?p=194




Chef::Log.info("****** --------------- Run DBMigrate  -----------------******")
# Run DB migration
#1
#2
#3
#4

Chef::Log.info("****** --------------- Update Symlink -----------------******")






