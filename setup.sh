#!/usr/bin/env bash
site=$1

mkdir -p /etc/facter/facts.d/

cat <<EOF > /etc/facter/facts.d/site.yaml
---
deploysite: $site
EOF
