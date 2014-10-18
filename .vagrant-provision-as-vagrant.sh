#!/bin/bash
set -o errexit
set -o xtrace

if ! rbenv --version ; then
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

if ! ls ~/.autoenv ; then
  git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
fi

ln -svf /vagrant/.vagrant-skel/bashrc /home/vagrant/.bashrc
ln -svf /vagrant/.vagrant-skel/profile /home/vagrant/.profile

source ~/.profile

cd /vagrant

if rbenv version 2>&1 | grep 'not installed' ; then
  rbenv install
fi

#Activate rbenv
cd $PWD

if ! gem list | grep bundle ; then
  gem install bundler
  rbenv rehash
fi

if ! bundle check ; then
  bundle
fi

npm config set registry http://registry.npmjs.org/
