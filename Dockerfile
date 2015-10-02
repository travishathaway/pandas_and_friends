FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init", "--", "bash", "-l"]

# Install python dev libs and npm libs
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive  apt-get upgrade -y --force-yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install \
        g++ libpcre3 libpcre3-dev make curl zlib1g-dev build-essential \
        libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
        libxml2-dev libxslt1-dev libcurl4-openssl-dev libgdbm-dev \
        libncurses5-dev automake libtool bison python-pip \
        git-core libpq-dev \
        python-virtualenv libffi-dev python-dev npm -y --force-yes

# Install pandas and friends
ADD ./py_libs.txt /tmp/py_libs.txt
RUN easy_install -U setuptools
RUN pip install -r /tmp/py_libs.txt
RUN rm /tmp/py_libs.txt

# Weird hack for debian systems
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Setup js dependencies
RUN npm install -g bower coffee-script grunt-cli
