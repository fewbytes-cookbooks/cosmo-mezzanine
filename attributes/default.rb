include_attribute 'gunicorn'
default['gunicorn']['virtualenv'] = '/var/mezzanine/virtualenv'
default['mezzanine']['app_name'] = 'app'
# TODO LATER: default['mezzanine']['app_dir'] = ... virtualenv/app_name ...
default['mezzanine']['gunicorn_config_file'] = '/etc/mezzanine_gunicorn.conf'
