Chef::Log.info("****** Run Migrations ******") 

bash 'Run migrations' do
  user "root"
  cwd "/tmp" 
  code <<-EOH
    cd /srv/www
    source venv/bin/activate
    cd /srv/www/current
    ## 01_syncdb:
    ## add hstore extension before running syncdb
    ./manage.py syncdb --noinput
    ## 03_collectstatic:
    ## 04_wsgipass:
    ## 05_migrations:
    ./manage.py migrate --noinput 
    ## 06_data:
    ./manage.py loaddata city_data.json barangay_data.json language_data.json error_message_data.json error_translation_data.json
  EOH
end