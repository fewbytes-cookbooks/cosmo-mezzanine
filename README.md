Description
===========

Installs and manages Mezzanine application(s) under [Cosmo](https://github.com/CloudifySource/cosmo-manager).

Requirements
============

Attributes
==========

* Uses `node['gunicorn']['virtualenv']` from the `gunicorn` cookbook.
* `node['injected']['mezzanine_db_host']` - put the IP of the DB server here.

Usage
=====

    include_recipe "nginx"
    include_recipe "gunicorn"

    # Global setup
    include_recipe "mezzanine::install"

    # App deploy
    mezzanine_app "test1" do
      git_repository "https://github.com/ilyash/mezzanine-test-app.git"
      port 8080
    end

    # Connect to DB
    mezzanine_app_configure_db "test1" do
    end

    # App start
    mezzanine_app_start "test1" do
    end

TODO
====
  * Convert to [LWRP](http://docs.opscode.com/chef/lwrps_custom.html)s
