# Use the official PHP image with FPM
FROM php:8.2-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd pdo pdo_mysql

# Set the working directory
WORKDIR /var/www

# Copy the existing application directory contents
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install

# Set permissions for storage and bootstrap/cache
# RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache 
# RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache
RUN chown -R www-data:www-data /var/www

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
  chown -R $user:$user /home/$user

# Set the user
USER $user