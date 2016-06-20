#!/bin/bash
# ******************************************
# Script : Self'Host
# Developer: RAW A.K.A Jasht'sSerie
# ******************************************
#Dir's.
confdir="/etc/apache2/sites-available"
vhostdir="/var/www"
skeleton="/opt/skeletonhost"

die () {
echo >&2 "$@"
 exit 1
}

# Check if we have an argument, Die If Not.!
[ "$#" -eq 1 ] || die "We Can't Start Without A Domain Name Please Use ./vh.sh domainname.com"

# Create folder for domain
mkdir $vhostdir/$1
chmod 775 $vhostdir/$1
mkdir $vhostdir/$1/public_html
chmod 775 $vhostdir/$1/public_html

# Creating Conf File.
cat <<EOF > /etc/apache2/sites-available/$1.conf
<VirtualHost *:80>
   ServerAdmin webmaster@$1
   ServerName $1
   ServerAlias www.$1
   DocumentRoot /var/www/$1/public_html
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
   <Directory $vhostdir/$1>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Order allow,deny
                allow from all
   </Directory>
</virtualhost>
EOF

#Easy Mysql.
cd /$vhostdir/$1/public_html
mkdir mysql
chown -R www-data:www-data mysql
cd mysql/
wget https://github.com/calvinlough/sqlbuddy/raw/gh-pages/sqlbuddy.zip
apt-get install zip unzip
unzip sqlbuddy.zip
mv sqlbuddy/* ./
rm -Rf sqlbuddy.zip
cd

#Enable & Reload.
sudo a2ensite $1.conf
service apache2 restart

#Downloading Wordpress.
cd /$vhostdir/$1/public_html
wget http://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* ./
rm -Rf latest.zip
rm -Rf wordpress
chown -R www-data:www-data *

#Creating .htaccess
cat <<EOF > /$vhostdir/$1/public_html/.htaccess
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
php_value upload_max_filesize 640M
php_value post_max_size 640M
php_value max_execution_time 3000
php_value max_input_time 3000
EOF

#Chown.
chown -R www-data:www-data /$vhostdir/$1/public_html/*

# Work Done.
echo "Domain creation of $1 is complete."
echo "Domain Folder $vhostdir/$1/public_html"
echo "You Can Connect To Mysql From Here http://$1/mysql/"
echo "Please Complete Wordpress Installation By Visit http://$1/"
echo "For More Tricks Visit http://hitechlinux.com/"
