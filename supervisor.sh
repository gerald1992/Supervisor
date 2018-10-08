#!/bin/bash

apt-get update && apt-get install python-setuptools -y && \
easy_install supervisor  && \
cd /home/ubuntu/ && \
dir1="//home/ubuntu/Supervisor" && \
if [[ ! -e $dir1 ]]; then
    mkdir $dir1
elif [[ ! -d $dir1 ]]; then
    echo "$dir1 already exists" 1>&2
    exit 0
fi && \
cd Supervisor && \
git init && \
git config user.email "gerald@photoup.net" && \
git config user.name "gerald1992" && \
git pull https://gerald1992:B4dmin09HJ321@github.com/gerald1992/Supervisor master && \


dir1="/etc/supervisor" && \
if [[ ! -e $dir1 ]]; then
    mkdir $dir1
elif [[ ! -d $dir1 ]]; then
    echo "$dir1 already exists" 1>&2
    exit 0
fi && \

echo_supervisord_conf >  /etc/supervisor/supervisord.conf && \
sed -i '$ a [include]' /etc/supervisor/supervisord.conf && \
sed -i '$ a files=conf.d/*.conf' /etc/supervisor/supervisord.conf && \


file1="/etc/systemd/system/supervisord.service" && \
if [[ ! -e $file1 ]]; then
    cp /home/ubuntu/Supervisor/systemd/supervisord.service /etc/systemd/system/
elif [[ ! -f $file1 ]]; then
    echo "$file1 already exists" 1>&2
    exit 0
fi && \

systemctl daemon-reload && \
systemctl start supervisord.service && \

dir2="/home/ubuntu/worker/" && \

if [[ ! -e $dir2 ]]; then
    mkdir $dir2 
elif [[ ! -d $dir2 ]]; then
    echo "$dir2 already exists" 1>&2
    exit 0
fi && \

cp -R /home/ubuntu/Supervisor/worker/* /home/ubuntu/worker/ && \

apt-get update   && \
apt-get autoremove -y && \
apt-get install -y git-core libapache2-mod-php7.0 php-all-dev php7.0 php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-gd php7.0-gmp php7.0-json php7.0-ldap php7.0-mysql php7.0-odbc php7.0-opcache php7.0-pgsql php7.0-pspell php7.0-readline php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xml php7.0-xmlrpc libphp7.0-embed php7.0-bcmath php7.0-bz2 php7.0-enchant php7.0-fpm php7.0-imap php7.0-interbase php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-phpdbg php7.0-soap php7.0-sybase php7.0-xsl php7.0-zip php7.0-dba && \
apt-get install -y composer   && \
cd /home/ubuntu/worker/ && \
composer install && \
cd ~ && \

dir3="/etc/supervisor/conf.d" && \
if [[ ! -e $dir3 ]]; then
    mkdir $dir3 
elif [[ ! -d $dir3 ]]; then
    echo "$dir3 already exists" 1>&2
    exit 0
fi && \

cp /home/ubuntu/Supervisor/conf.d/php-worker.conf /etc/supervisor/conf.d/ && \

sed -i -e  '22s/^;//' /etc/supervisor/supervisord.conf && \
sed -i -e  '23s/^;//' /etc/supervisor/supervisord.conf && \
sed -i -e  '24s/^;//' /etc/supervisor/supervisord.conf && \
sed -i -e  '25s/^;//' /etc/supervisor/supervisord.conf && \
sed -i -e  '23s/port=127.0.0.1:9001/port=*:9001/g' /etc/supervisor/supervisord.conf && \
sed -i -e  '24s/username=user/username=admin/g' /etc/supervisor/supervisord.conf && \
sed -i -e  '25s/password=123/password=1234/g' /etc/supervisor/supervisord.conf && \
sed -i -e  '58s/^;//' /etc/supervisor/supervisord.conf && \
systemctl restart supervisord.service 
