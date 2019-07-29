#!/usr/bin/env bash

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Import script args ==

timezone=$(echo "$1")
mysql_root_password=$(echo "$2")

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password >> /app_web/vagrant_build.log 2>&1

info "Update OS software"
apt-get update -y >> /app_web/vagrant_build.log 2>&1
apt-get upgrade -y >> /app_web/vagrant_build.log 2>&1

info "Install dependency software"
apt-get install -y curl htop debconf-utils dirmngr unzip apt-transport-https sudo git libpng-dev gcc g++ make >> /app_web/vagrant_build.log 2>&1

info "Adding PHP7 GPG key"
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >> /app_web/vagrant_build.log 2>&1

info "Adding MySQL GPG key"
wget -O /tmp/RPM-GPG-KEY-mysql https://repo.mysql.com/RPM-GPG-KEY-mysql >> /app_web/vagrant_build.log 2>&1
apt-key add /tmp/RPM-GPG-KEY-mysql >> /app_web/vagrant_build.log 2>&1

info "Adding PHP 7 packages repo"
echo 'deb https://packages.sury.org/php/ stretch main' | tee -a /etc/apt/sources.list >> /app_web/vagrant_build.log 2>&1

info "Adding MySQL package repo"
echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-5.7" | tee /etc/apt/sources.list.d/mysql.list >> /app_web/vagrant_build.log 2>&1

info "Updating package lists after adding repos"
apt-get update -y >> /app_web/vagrant_build.log 2>&1

info "Prepare MySQL root password"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password ${mysql_root_password}"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password ${mysql_root_password}"

info "Installing Apache server"
apt-get install -y apache2 >> /app_web/vagrant_build.log 2>&1

info "Installing MySQL server"
apt-get install -y mysql-server >> /app_web/vagrant_build.log 2>&1

info "Installing PHP stuff"
apt-get install -y libapache2-mod-php7.3 php7.3 php7.3-pdo php7.3-mysql php7.3-mbstring php7.3-xml php7.3-intl php7.3-tokenizer php7.3-gd php7.3-imagick php7.3-curl php7.3-zip php7.3-cli php7.3-fpm php-xdebug >> /app_web/vagrant_build.log 2>&1

info "Installing Composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer >> /app_web/vagrant_build.log 2>&1

info "Installing Node.js"
curl -sL https://deb.nodesource.com/setup_10.x | bash - >> /app_web/vagrant_build.log 2>&1
apt-get install -y nodejs >> /app_web/vagrant_build.log 2>&1

info "Configuring Apache"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
a2enmod rewrite >> /app_web/vagrant_build.log 2>&1

info "Configuring MySQL"
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

info "Configuring PHP-FPM"
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's/owner = www-data/owner = vagrant/g' /etc/php/7.3/fpm/pool.d/www.conf

info "Configuring xDebug"
cat << EOF > /etc/php/7.3/mods-available/xdebug.ini
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_autostart=1
EOF

info "Configuring document root"
if [ ! -L /var/www/html ]; then
    if [ ! -d /app_web ]; then
        sudo mkdir -p /app_web
    fi
    sudo rm -rf /var/www/html
    sudo ln -fs /app_web /var/www/html
fi

info "Restarting Apache"
/etc/init.d/apache2 restart >> /app_web/vagrant_build.log 2>&1