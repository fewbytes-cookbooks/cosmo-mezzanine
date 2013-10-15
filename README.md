Description
===========

Requirements
============

Attributes
==========

* Uses `node['gunicorn']['virtualenv']` from the `gunicorn` cookbook.

Usage
=====

    mezzanine_app do
      git_repository "https://github.com/XXX/YYY.git"
      port N         # gunicorn port to listen on
      hostname H     # hostname to respond on (default is nil, respond to any hostname)
    end
