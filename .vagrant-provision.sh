#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -o errexit
set -o xtrace

apt-get update -yq
apt-get install -yq \
  build-essential \
  curl \
  git \
  libpq-dev \
  libreadline-dev \
  libssl-dev \
  postgresql-9.3 \
  memcached \
  libsqlite3-dev \
  vim-nox

if ! /opt/node/bin/node --version ; then
  curl -s 'http://nodejs.org/dist/v0.10.31/node-v0.10.31-linux-x64.tar.gz' | tar -C /opt/ -xvzf -
  ln -svf /opt/node-v0.10.31-linux-x64 /opt/node
fi

su - postgres -c /vagrant/.vagrant-provision-as-postgres.sh
su - vagrant -c /vagrant/.vagrant-provision-as-vagrant.sh
