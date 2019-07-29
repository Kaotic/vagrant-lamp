#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Import script args ==

github_token=$(echo "$1")
mysql_root_password=$(echo "$2")

#== Provision script ==

info "Provision-script user: `whoami`"

info "Configure composer"
composer config --global github-oauth.github.com ${github_token} >> /app_web/vagrant_build.log 2>&1

info "Creating alias for quick access to the MySQL (just type: db)"
echo 'alias db="mysql -u root -p${mysql_root_password}"' | tee /home/vagrant/.bash_aliases

info "Creating alias for quick access to the app_web (just type: app_web)"
echo 'alias app_web="cd /app_web"' | tee /home/vagrant/.bash_aliases

info "Creating alias for quick access to the app_nodejs (just type: app_nodejs)"
echo 'alias app_nodejs="cd /app_nodejs"' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc