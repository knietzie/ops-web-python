Chef::Log.info("****** Setup deployment directory ******")
data_dir = value_for_platform(
  "amazon" => { "default" => "/srv/www" },
  "centos" => { "default" => "/srv/www" }
)

# Create deployment directory
directory data_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end

# Create default python logs - later to modify 
# touch /opt/python/log/mobilecrashlogs
log_dir = "/opt/python/log"
directory log_dir do
  mode 0755
  owner 'root'
  group 'root'
  recursive true
  action :create
end  

#Creare mobilecrashlogs file
execute "create_mobilecrashlogs" do
    command "sudo touch /opt/python/log/mobilecrashlog"
end  


Chef::Log.info("****** Installing container applications ******")
bash 'install' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    yum update 
    yum -y install httpd httpd-devel python python-devel python python27-devel make git gcc gcc-c++ uuid libuuid-devel mysql-devel postgresql93 postgresql93-devel postgresql-devel
    EOH
end

#******* Enable this in AWS Production **********
execute "install_EPEL" do
  command "rpm -qa | grep -qw  epel-release-6-8.noarch | rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
#     # command "yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end
#******* Enable this in AWS Production **********


####### Using NGINX Install nginx ------
# sudo yum install epel-release
# https://www.digitalocean.com/community/tutorials/how-to-deploy-python-wsgi-apps-using-gunicorn-http-server-behind-nginx


execute "install Nginx webserver" do
  command "yum -y install nginx"
end

# start nginx
execute "start_nginx" do
  command "sudo service nginx start"
end


####### Using NGINX Install nginx ------

execute "install_pip" do
    command "yum -y install python-pip"
end  

execute "update_pip" do
    command "sudo pip install --upgrade pip"
end  

# execute "install_mod_wsgi" do
#     command "yum -y install mod_wsgi"
# end  

# execute "Load_mod_wsgi module" do
#     command "echo 'LoadModule wsgi_module modules/mod_wsgi.so' > /etc/httpd/conf.d/wsgi.conf"
# end    

#Use WSGI.conf.erb template
# template "/etc/httpd/conf.d/wsgi.conf" do
#   source "wsgi.conf.erb"
# end

###  ---------- WSGI SETTINHGS  ##############
####  https://docs.djangoproject.com/en/1.8/howto/deployment/wsgi/modwsgi/

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

# Chef::Log.info("****** Start Httpd ******")
# service 'httpd' do
#   action [ :disable, :stop ]
# end

# Install virtualenv via Pip
# virtualenv venv
# source venv/bin/activate
#

execute "install_virtualenv" do
    command "sudo pip install virtualenv"
end  

#setup virtual environemnt (/srv/wwww/venv)
bash 'activate_virtualenv' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www
    virtualenv venv --python=/usr/local/bin/python
    source venv/bin/activate
    venv/bin/pip install --upgrade pip
    venv/bin/pip install gunicorn
  EOH
end

# Install python2.7 via venv
# bash 'install_python2.7' do
#   user "root"
#   cwd "/tmp"
#   code <<-EOH
#     /srv/www/venv/bin/easy_install install python2.7
#   EOH
# end 


Chef::Log.info("****** --------------- Start of Deployment -----------------******")


# Initial deploy
# bash 'deploy' do
#   user "root"
#   cwd "/tmp"
#   code <<-EOH
#     /srv/www/venv/bin/easy_install install python2.7
#   EOH
# end 


Chef::Log.info("****** --------------- Pull From Repo -----------------******")
# - Pull from repo
# - Set symnlinks
#git clone -b develop git@github.com:user/myproject.git
# http://www.rootdown.net/blog/2012/04/10/introducing-deploy-wrapper/
# After pullout, go to virtualenv
# Install requirements.txt
# Restart httpd


# execute "Python2.7 install Python2.7" do
#     command "sudo /srv/www/venv/bin/easy_install install python2.7"
# end  

# Notes on installing python, it should be 2.7 to avoid compatibility inssues
# http://tuxlabs.com/?p=194
#



Chef::Log.info("****** --------------- Run DBMigrate  -----------------******")
# Run DB migration
#1
#2
#3
#4

# deploy "#{node[:app][:dir]}" do
#     repo "#{node[:app][:repo]}"
#     revision "#{node[:app][:branch]}"
#     user "deploy"
#     #owner "deploy
#     purge_before_symlink %w{tmp log}
#     create_dirs_before_symlink ["tmp"]
#     #symlink_before_migrate "system/database.js" => "config/database-sim.js"
#     symlinks "pids"=>"tmp/pids", "log"=>"log"

# end
Chef::Log.info("****** --------------- Update Symlink -----------------******")


