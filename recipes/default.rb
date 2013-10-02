#
# Cookbook Name:: mezzanine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# TODO: run as non-root

include_recipe "python::pip"
include_recipe "python::virtualenv"
include_recipe "nginx"
include_recipe "gunicorn"
include_recipe "runit"

virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
python_bin = "#{virtualenv_dir}/bin/python"

# TODO LATER: use node['mezzanine']['app_dir']
app_dir = File.join(virtualenv_dir, node['mezzanine']['app_name'])

%w(libjpeg-dev python-dev git-core libpq-dev memcached supervisor).each do |p|
  apt_package p
end

%w(Mezzanine setproctitle south psycopg2 django-compressor python-memcached).each do |p|
  python_pip p do
    action :install
    virtualenv virtualenv_dir
  end
end

# TODO: replace this part with one that brings a real application - start
execute "Create mezzanine project at #{app_dir}" do
  command "#{virtualenv_dir}/bin/mezzanine-project #{app_dir}"
  creates app_dir
end
# TODO: replace this part with one that brings a real application - end

execute "Create DB for project at #{app_dir}" do
  cwd app_dir
  command "#{python_bin} manage.py createdb --noinput --nodata"
  creates "#{app_dir}/dev.db"
end

execute "Collect static files for project at #{app_dir}" do
  cwd app_dir
  command "#{python_bin} manage.py collectstatic"
  creates "#{app_dir}/static"
end

runit_service "mezzanine" do
  options ({
    :app_name => node['mezzanine']['app_name'],
    :virtualenv_dir => virtualenv_dir,
  })
  default_logger true
end

template "#{node['nginx']['dir']}/sites-available/mezzanine" do
  source "nginx-mezzanine.erb"
  variables :app_dir => app_dir
  notifies :reload, "service[nginx]"
end

nginx_site "mezzanine"

service "mezzanine" do
  action :start
end
