#!/bin/bash
# ******************************************
# Script : Self'Host
# Developer: RAW A.K.A Jasht'sSerie
# ******************************************
if [ "`lsb_release -is`" == "Ubuntu" ] || [ "`lsb_release -is`" == "Debian" ] || [ "`lsb_release -is`" == "Zorin" ]
then
       sudo apt-get update -y
       sudo apt-get upgrade -y
       apt-get install apache2 -y
       apt-get install php5 -y
       apt-get install -y libapache2-mod-php5 php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-ming php5-ps
       apt-get install -y php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
       sudo service apache2 restart
       apt-get install mysql-server mysql-client -y
       sudo php5enmod mcrypt
       service apache2 restart
       cd /var
       cd www/
       cd html/
       mkdir phpmyadmin
       sudo chown -R www-data:www-data phpmyadmin/
       cd phpmyadmin/
       wget https://github.com/calvinlough/sqlbuddy/raw/gh-pages/sqlbuddy.zip
       apt-get install zip unzip
       unzip sqlbuddy.zip
       mv sqlbuddy/* ./
       rm -Rf sqlbuddy.zip
       cd
       sudo a2enmod rewrite
       service apache2 restart
       echo "Apache, Mysql, Php, Is Installed On Your System"
       echo "If you want to start with Virtual Host Creator Please Execute sudo ./vh.sh yourdomain.com"
      echo "For more easy tricks please visit my website http://hitechlinux.com/ "
fi
