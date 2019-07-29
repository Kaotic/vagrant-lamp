## Features
- Configurable
- Auto update host file (```debdev.local``` by default)
- Ready for web apps & Node.js apps (auto synchronization)
- xDebug installed (port 9000)
- Alias commands for quick access (```app_web, app_nodejs, db```)
- Composer auto init github token

## Pre-installed packages on Debian 9 (Skretch)
 * Apache 2.4
 * PHP 7.3
 * MySQL 5.7
 * Git
 * Composer
 * Node v10 LTS

## Include PHP extensions
  * php7.3-pdo
  * php7.3-mysql
  * php7.3-mbstring
  * php7.3-xml
  * php7.3-intl
  * php7.3-tokenizer
  * php7.3-gd
  * php7.3-imagick
  * php7.3-curl
  * php7.3-zip
  * php7.3-cli
  * php7.3-fpm
  * php-xdebug

## Configurations

1. In directory ```vagrant/config``` copy ```vagrant-local.example.yml``` file and rename it ```vagrant-local.yml``` and change your settings.
2. If you want use Virtual Hosts use ```domains``` variable in ```VagrantFile``` and follow comment in line 73

## Usage
```bash
cd yourProject
git clone https://github.com/Kaotic/vagrant-lamp.git .
vagrant up
vagrant ssh #Connect to SSH.
```