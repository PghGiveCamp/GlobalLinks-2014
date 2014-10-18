#!/bin/bash
set -o errexit
set -o xtrace

if ! $(psql -c '\du' | grep -q globallinks) ; then
  psql -c "CREATE USER globallinks WITH SUPERUSER LOGIN PASSWORD 'globallinks'";
fi

if ! $(psql -c '\d' | grep -q globallinks ) ; then
  createdb --owner globallinks globallinks
fi
