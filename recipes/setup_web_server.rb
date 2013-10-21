#
# Cookbook Name:: mezzanine
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# TODO
#   * run as non-root
#   * one virtualenv per app

include_recipe "apt" # Otherwise apt packages install can fail because of stale apt cache
include_recipe "python::pip"
include_recipe "python::virtualenv"
include_recipe "runit"

if not node['gunicorn']
  Chef::Application.fatal!("mezzanine requires gunicorn")
end

virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
python_bin = "#{virtualenv_dir}/bin/python"

directory "#{virtualenv_dir}/app" do
end


%w(libjpeg-dev python-dev git-core libpq-dev memcached supervisor).each do |p|
  apt_package p
end

%w(Mezzanine setproctitle south psycopg2 django-compressor python-memcached).each do |p|
  python_pip p do
    action :install
    virtualenv virtualenv_dir
  end
end
