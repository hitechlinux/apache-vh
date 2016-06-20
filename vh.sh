#!/bin/bash
# ******************************************
# Script : Self'Host
# Developer: RAW A.K.A Jasht'sSerie
# Website   : hitechlinux.com
# Date: 08.05.2016
# Last Updated: 28.05.2016
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
sudo chown -R www-data:www-data mysql/
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

#Welcome Index.
{
echo "<html>"
echo "<center><h1> WELCOME </h1></center>"
echo "</html>"
} > "/var/www/$1/public_html/index.html"
# Work Done.
echo "Domain creation of $1 is complete." 
echo "You can place your files in $vhostdir/$1/public_html" 
echo "You Can Connect To Mysql From Here http://$1/mysql/"
echo "For More Tricks Visit http://hitechlinux.com/"
