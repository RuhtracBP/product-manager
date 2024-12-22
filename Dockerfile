FROM dunglas/frankenphp

RUN install-php-extensions \
  pcntl \
  pdo_mysql \
  opcache   
# Add other PHP extensions here...

COPY . /app

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]