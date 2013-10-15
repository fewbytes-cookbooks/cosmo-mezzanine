# Based on
# https://github.com/stephenmcd/mezzanine/blob/master/mezzanine/project_template/fabfile.py

# TODO: use lwrps

# Tested on Ubuntu 12.04 LTS

maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures mezzanine"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "apt"
depends "gunicorn"
depends "nginx"
depends "postgresql"
depends "python"
depends "runit"
