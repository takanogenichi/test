FROM ubuntu:latest

RUN apt-get -y update && apt-get -y install apache2

RUN apt-get -y update && apt-get -y install php
RUN apt-get -y update && apt-get -y install php-xml

RUN apt-get update && apt-get install -y --no-install-recommends \
     mariadb-client \
     libonig-dev \
     libjpeg-dev \
     libpng-dev \
     libzip-dev \
     libmagickwand-dev \
     libmcrypt-dev \
     libcurl4-openssl-dev \
     libsmbclient-dev \
     git \
     zip \
     chromium \
# 以下コメントアウトしたが何をしているか不明、↑まではちゃんと動くことは確認しています、もしかしたら進学のやつを参考にさせてもらったら、他のも参考になる？
#   && docker-php-ext-configure gd \
#   && docker-php-ext-install gd \
#   && docker-php-ext-install zip \
#   && docker-php-ext-install exif \
#   && docker-php-ext-install mbstring \
#   && docker-php-ext-install sockets \
#   && docker-php-ext-install mysqli pdo pdo_mysql \
   && rm -rf /var/lib/apt/lists/*

#RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
# やっぱりこっちのが良さげ
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Put apache config for Laravel
# 以下2行コメントアウトしたが何をしているか不明(もしかしたら、www配下なら動作するかも。) => AxolConvertMeijinなら多分ちゃんと動く、ファイルがみつかった。
COPY apache2-laravel.conf /etc/apache2/sites-available/laravel.conf
RUN a2dissite 000-default.conf && a2ensite laravel.conf && a2enmod rewrite

# rootでcomposer install する場合は下記がひつよう。
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_NO_INTERACTION 1

# 以下は必要に応じる
#EXPOSE 8080
#USER www

CMD sh -c "ls -lat /var/www/html && pwd";sh -c "which composer";sh -c "cd /var/www/html && composer install --no-dev --optimize-autoloader --ignore-platform-reqs";sh -c "cd /var/www/html && php artisan config:cache";sh -c "tail -f /dev/null"
#CMD sh -c "ls -lat && pwd";sh -c "tail -f /dev/null"
