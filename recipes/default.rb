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


ams_log_dir = "srv/www/shared/log"
directory ams_log_dir do
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


Chef::Log.info("****** Install essentials ******")
bash 'install essentials' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    yum update 
    yum -y install make automake git-core gcc gcc-c++ kernel-devel uuid libuuid-devel mysql-devel postgresql93 postgresql93-devel postgresql-devel
  EOH
end


#******* Enable this in AWS Production **********
execute "install_EPEL" do
  command "rpm -qa | grep -qw  epel-release-6-8.noarch | rpm -i --force http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
#     # command "yum -y install http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
end
#******* Enable this in AWS Production **********

####### Using NGINX Install nginx ------
##
# Install nginx
execute "Install_nginx" do
  command "yum -y install nginx"
end

# Add gunicorn.conf
template "gunicorn.conf" do
  path "/etc/nginx/conf.d/gunicorn.conf"
  source "gunicorn.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# Replace default nginx.com file
execute "replace nginx.conf" do
  command "sudo rm /etc/nginx/nginx.conf"
end

template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# start nginx
execute "start_nginx" do
  command "sudo service nginx start"
end
##
####### Using NGINX Install nginx ------

template "wrap-ssh4git.sh" do
  path "/root/.ssh/wrap-ssh4git.sh"
  source "wrap-ssh4git.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end


########################################
# install build tools 
#sudo yum install make automake gcc gcc-c++ kernel-devel git-core -y 

# install python 2.7 and change default python symlink 
########################################
bash 'install python 2.7' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    yum -y install python27-devel
    rm /usr/bin/python
    ln -s /usr/bin/python2.7 /usr/bin/python 
  EOH
end

    # # yum still needs 2.6, so write it in and backup script 
    # cp /usr/bin/yum /usr/bin/_yum_before_27 
    # sed -i s/python/python2.6/g /usr/bin/yum 
    # sed -i s/python2.6/python2.6/g /usr/bin/yum 

bash 'install pip for python 2.7' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    curl -o /tmp/ez_setup.py https://bootstrap.pypa.io/ez_setup.py
    sudo /usr/bin/python27 /tmp/ez_setup.py 
    sudo /usr/bin/easy_install-2.7 pip 
    sudo pip install virtualenv
  EOH
end
########################################




# execute "install_pip" do
#   command "yum -y install python-pip"
# end  

# execute "update pip" do
#   command "sudo pip-2.7 install --upgrade pip" 
# end

# execute "install_virtualenv" do
#   command "sudo pip install virtualenv"
# end  

#setup virtual environemnt (/srv/wwww/venv)
bash 'activate_virtualenv' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www
    virtualenv venv
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


