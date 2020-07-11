FROM php:apache as develop

RUN mkdir -p /opt/ibm/dsdriver
ADD dsdriver /opt/ibm/dsdriver

RUN ls -la /opt/ibm/dsdriver
# Use the default production configuration

COPY entry-point.sh /entry-point.sh
RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=ibm-db2,/opt/ibm/dsdriver/clidriver && \ 
    docker-php-ext-install pdo_odbc && \
    cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" 
#  /opt/ibm/dsdriver/clidriver
RUN echo "/opt/ibm/dsdriver/clidriver" | pecl install ibm_db2
RUN echo "extension=ibm_db2.so" >> $PHP_INI_DIR/php.ini
RUN chown -R www-data:www-data /opt/ibm/dsdriver
RUN docker-php-ext-install pdo_mysql
#RUN cd /opt/ibm/dsdriver/clidriver && php validate_install.php sample mydb2 50000 db2inst1 t3sla

WORKDIR /var/www/html
RUN apt-get update && apt-get install vim nano wget git zip libzip-dev libldap2-dev -y && \
    wget https://getcomposer.org/composer-stable.phar -O composer.phar && mkdir -p /usr/local/bin && mv composer.phar /usr/local/bin/composer && chmod 755 /usr/local/bin/composer
RUN docker-php-ext-install zip

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN apt-get install -y exim4 &&\
  echo 'sendmail_path = "/usr/sbin/exim4 -t"' >> /usr/local/etc/php/conf.d/mail.ini && \
  echo 'SMTP = localhost' >> /usr/local/etc/php/conf.d/mail.ini && \
  echo 'smtp_port = 25' >> /usr/local/etc/php/conf.d/mail.ini 
COPY etc/exim4/exim4.conf /etc/exim4/exim4.conf
RUN chmod 644 /etc/exim4/exim4.conf

RUN composer global require hirak/prestissimo
#RUN pecl install -f xdebug && \
#echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini
#
#ENV XDEBUG_CONFIG="remote_host=host.docker.internal remote_port=9000 remote_enable=1"

#RUN /usr/sbin/a2ensite default-ssl
#RUN /usr/sbin/a2enmod ssl 
RUN /usr/sbin/a2enmod rewrite
EXPOSE 80
#EXPOSE 443
