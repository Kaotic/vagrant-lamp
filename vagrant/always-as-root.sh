#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

info "Restart web-stack"
service php7.3-fpm restart >> /app_web/vagrant_build.log 2>&1
service apache2 restart >> /app_web/vagrant_build.log 2>&1
service mysql restart >> /app_web/vagrant_build.log 2>&1