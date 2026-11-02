# shiksha_setu

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Web version (GitHub Pages)

`lib/main_web.dart` is the browser entry (server-backed app only). `.github/workflows/deploy-web.yml`
builds three copies on every push to `main`: `/` is PROD, `/uat/` is UAT, `/debug/` is DEBUG.

- Pick the copy at build time: `--dart-define=APP_ENV=debug|uat|prod` (non-prod shows a corner ribbon).
- Point it at a server: `--dart-define=API_BASE_URL=...`. Set repository variables
  `API_URL_DEBUG` (default `http://127.0.0.1:8000/api`), `API_URL_UAT`, `API_URL_PROD`.
- Local run: `flutter run -d chrome -t lib/main_web.dart --dart-define=APP_ENV=debug`.
- Until a live server exists, the DEBUG copy talks to the Django server on the viewer's own
  computer, so it only works on the machine that runs it. Start Django with
  `DJANGO_DEBUG=true CORS_ALLOWED_ORIGINS=https://<user>.github.io .venv/bin/python manage.py runserver`.
- GitHub Pages is public on a free plan: do not put real school data behind a public URL.
