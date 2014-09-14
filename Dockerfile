FROM ubuntu:14.04
MAINTAINER Luis Elizondo "lelizondo@gmail.com"

RUN apt-get --fix-missing update
RUN apt-get -y install apache2 php5 git curl php5-mcrypt php5-json php5-mysql libapache2-mod-php5
RUN apt-get -y install php5-common php5-curl php5-gd php5-dev
RUN apt-get -y install php5-mcrypt
RUN apt-get -y autoremove 
RUN apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN echo "extension=mcrypt.so" >> /etc/php5/apache2/conf.d/20-mcrypt.ini
RUN echo "extension=mcrypt.so" >> /etc/php5/cli/conf.d/20-mcrypt.ini

RUN /usr/sbin/a2enmod rewrite

RUN /usr/sbin/a2enmod socache_shmcb || true

RUN service apache2 restart

RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN composer create-project laravel/laravel /var/www/app --prefer-dist

ADD config/default /etc/apache2/sites-available/000-default.conf
ADD config/default-ssl /etc/apache2/sites-available/default-ssl.conf

RUN /bin/ln -sf ../sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN /bin/ln -sf ../sites-available/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
RUN /bin/ln -sf ../mods-available/ssl.conf /etc/apache2/mods-enabled/
RUN /bin/ln -sf ../mods-available/ssl.load /etc/apache2/mods-enabled/

RUN /bin/chown www-data:www-data -R /var/www

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]