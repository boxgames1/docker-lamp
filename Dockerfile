FROM ubuntu:16.04
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 16.04 LTS. Includes .htaccess support and popular PHP5.5 features, including composer and mail() function." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql boxgames1/lamp" \
	Version="1.0"

RUN apt-get update
RUN apt-get upgrade -y

COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y \
	php5.5.0 \
	php5.5.0-bz2 \
	php5.5.0-cgi \
	php5.5.0-cli \
	php5.5.0-common \
	php5.5.0-curl \
	php5.5.0-dev \
	php5.5.0-enchant \
	php5.5.0-fpm \
	php5.5.0-gd \
	php5.5.0-gmp \
	php5.5.0-imap \
	php5.5.0-interbase \
	php5.5.0-intl \
	php5.5.0-json \
	php5.5.0-ldap \
	php5.5.0-mcrypt \
	php5.5.0-mysql \
	php5.5.0-odbc \
	php5.5.0-opcache \
	php5.5.0-pgsql \
	php5.5.0-phpdbg \
	php5.5.0-pspell \
	php5.5.0-readline \
	php5.5.0-recode \
	php5.5.0-snmp \
	php5.5.0-sqlite3 \
	php5.5.0-sybase \
	php5.5.0-tidy \
	php5.5.0-xmlrpc \
	php5.5.0-xsl
RUN apt-get install apache2 libapache2-mod-php5.5.0 -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install postfix -y
RUN apt-get install git nodejs npm composer nano tree vim curl ftp -y
RUN npm install -g bower grunt-cli gulp

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY index.php /var/www/html/
COPY run-lamp.sh /usr/sbin/

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/run-lamp.sh"]
