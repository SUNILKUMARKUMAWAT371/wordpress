FROM ubuntu:20.04
MAINTAINER sunil
RUN apt-get update && apt-get install -y apt-utils && apt-get install -y curl tzdata
RUN apt-get install -y curl wget net-tools vim apache2 mysql-client \
    php \
    libapache2-mod-php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-soap \
    php-intl \
    php-zip && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
WORKDIR /var/www/wordpress
RUN chown www-data:www-data /var/www/wordpress
COPY --chown=www-data:www-data . .
COPY wordpress.conf /etc/apache2/sites-available
RUN rm -rf /var/www/wordpress/Dockerfile /var/www/wordpress/wordpress.conf
RUN a2ensite wordpress.conf && a2dissite 000-default.conf && a2enmod rewrite
RUN service apache2 restart && service apache2 reload
RUN apache2ctl configtest
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]

