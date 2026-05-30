# Laravel + Mailexam

Minimal [Laravel](https://laravel.com/) example that sends test mail through [Mailexam](https://mailexam.ru/) SMTP via Laravel Mail.

Based on the [Mailexam Laravel guide](https://wiki.mailexam.ru/en/examples/laravel/).

## What you need

- A Mailexam account and a project with SMTP credentials.
- PHP 8.3+ and [Composer](https://getcomposer.org/).

From your Mailexam welcome email or dashboard:

| Variable | Description |
|----------|-------------|
| `MAIL_USERNAME` | SMTP login (for example, `xxxxx`) |
| `MAIL_PASSWORD` | SMTP password (paired with the login) |
| `MAIL_HOST` | `{login}.mailexam.ru` (must match the login) |

## Quick start (host)

1. Install dependencies:

```bash
composer install
```

2. Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
php artisan key:generate
```

3. Edit `.env` — set Mailexam SMTP values from your welcome email:

```env
MAIL_MAILER=smtp
MAIL_SCHEME=smtp
MAIL_HOST=YOUR_LOGIN.mailexam.ru
MAIL_PORT=587
MAIL_USERNAME=YOUR_LOGIN
MAIL_PASSWORD=YOUR_PASSWORD
MAIL_FROM_ADDRESS=noreply@example.test
MAIL_FROM_NAME="${APP_NAME}"
```

4. Clear config cache after changes:

```bash
php artisan config:clear
```

5. Run the server:

```bash
php artisan serve
```

The server listens on `http://127.0.0.1:8000` by default.

6. Send a test message:

```bash
curl -X POST http://127.0.0.1:8000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

The message appears in the Mailexam dashboard → your project → inbox.

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `MAIL_MAILER` | yes | `smtp` | Use `smtp` for Mailexam |
| `MAIL_HOST` | yes | — | `{login}.mailexam.ru` |
| `MAIL_PORT` | no | `587` | SMTP port (`587`, `2525`, or `25`) |
| `MAIL_USERNAME` | yes | — | SMTP login |
| `MAIL_PASSWORD` | yes | — | SMTP password |
| `MAIL_SCHEME` | no | `smtp` | `smtp` for STARTTLS on 587; `smtps` for 465 |
| `MAIL_FROM_ADDRESS` | no | `noreply@example.test` | Sender address |
| `APP_KEY` | yes | — | Run `php artisan key:generate` |
| `HTTP_HOST` | no | `127.0.0.1` | HTTP bind address (Docker) |
| `HTTP_PORT` | no | `8000` | HTTP listen port (Docker) |

For port **587** use `MAIL_SCHEME=smtp` (STARTTLS). For port **465** use `MAIL_SCHEME=smtps`. For port **25** set `MAIL_SCHEME=null`.

## Project layout

```
.
├── app/Http/Controllers/MailController.php
├── routes/web.php
├── config/mail.php
├── .env.example
├── Dockerfile         # for local debugging only
└── docker-compose.yml
```

## Docker (debugging)

Docker is provided for local debugging. For day-to-day development, run the app on the host with `php artisan serve` (see above).

```bash
cp .env.example .env
php artisan key:generate
# edit .env with your Mailexam credentials

docker compose up --build
```

Then call the same endpoint on the mapped port:

```bash
curl -X POST http://127.0.0.1:8000/mail/test \
  -H 'Content-Type: application/json' \
  -d '{"to":"user@example.test","subject":"Test","body":"Hello"}'
```

Inside the container the server binds to `0.0.0.0:8000` so the port mapping works.

## CI

Set these secrets in your CI environment:

```yaml
variables:
  MAIL_MAILER: smtp
  MAIL_HOST: "${MAILEXAM_LOGIN}.mailexam.ru"
  MAIL_PORT: "587"
  MAIL_USERNAME: "${MAILEXAM_LOGIN}"
  MAIL_PASSWORD: "${MAILEXAM_PASSWORD}"
  MAIL_SCHEME: smtp
  MAIL_FROM_ADDRESS: "noreply@example.test"
```

After sending a message in a test, verify delivery via the [Mailexam API](https://mailexam.ru/api).

For unit tests without network use `MAIL_MAILER=array` or `log`.

## Troubleshooting

**Connection could not be established**

- `MAIL_HOST` must be `{login}.mailexam.ru`, same login as `MAIL_USERNAME`.
- Login and password must come from the same Mailexam project.
- Run `php artisan config:clear` after changing `.env`.

**419 CSRF token mismatch**

- The `/mail/test` route is excluded from CSRF validation for curl testing.

**Message not in the dashboard**

- Open the inbox of the same Mailexam project.
- Check `storage/logs/laravel.log` for SMTP errors.

## See also

- [Mailexam Laravel guide (wiki)](https://wiki.mailexam.ru/en/examples/laravel/)
- [Symfony reference implementation](https://github.com/mailexam/Symfony) — another PHP framework
- [Laravel Mail documentation](https://laravel.com/docs/mail)
- [Mailexam API documentation](https://mailexam.ru/api)
