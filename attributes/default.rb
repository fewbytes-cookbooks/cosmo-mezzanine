include_attribute 'gunicorn'
include_attribute 'postgresql'

# gunicorn
default['gunicorn']['virtualenv'] = '/var/mezzanine/virtualenv'

# postgresql
default['postgresql']['config']['listen_addresses'] = '0.0.0.0'
default['postgresql']['pg_hba'] = [
  {:comment => '# Allow from 10.X.X.X', :type => 'host', :db => 'all', :user => 'postgres', :addr => '10.0.0.0/8', :method => 'md5'}
]

# mezzanine
default['mezzanine']['gunicorn_config_file'] = '/etc/mezzanine_gunicorn.conf'
