FROM php:8.3-cli-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

COPY . .
RUN composer dump-autoload --optimize

ENV HTTP_HOST=0.0.0.0
ENV HTTP_PORT=8000

EXPOSE 8000

CMD ["sh", "-c", "php artisan serve --host=${HTTP_HOST} --port=${HTTP_PORT}"]
