#! /bin/sh

#if [ ! -f /usr/local/bin/composer ]; then
#    echo "composer not found, downloading..."
#    wget https://getcomposer.org/composer.phar && mkdir -p /usr/local/bin && mv composer.phar /usr/local/bin/composer && chmod 755 /usr/local/bin/composer
#fi
#composer install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
#php -S "0.0.0.0:${HTTP_PORT}" router.php
#CMD ["/usr/sbin/apachectl","-D","FOREGROUND"]
/usr/sbin/apachectl -D FOREGROUND


