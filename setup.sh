#!/usr/bin/env bash

site=$1

## if no args then abort
if [ $# -eq 0 ]; then
  echo "You must specify a site eg. 'setup.sh my.site.com'"
  exit 1
fi

## ensure that puppet is installed
if [ ! -f /usr/bin/puppet ]; then
  yum install -y puppet
fi

## create the site.yaml fact
if [ ! -f /etc/facter/facts.d/site.yaml ]; then
  if [ ! -d /etc/facter ];
  then
    mkdir -p /etc/facter/facts.d/
  fi
cat <<EOF > /etc/facter/facts.d/site.yaml
---
deploysite: $site
EOF

## create the hiera.yaml
rm -f /etc/hiera.yaml /etc/puppet/hiera.yaml
cp hostdata/hiera.yaml /etc/puppet/hiera.yaml
ln -s /etc/puppet/hiera.yaml /etc/hiera.yaml

else
  echo "site.yaml already exists, delete it if you want to specify a new site"

fi
