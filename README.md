# Flutter Dictionary App with Express Proxy

A Flutter dictionary app backed by a lightweight Express proxy wrapping `dictionaryapi.dev` to avoid CORS issues.

## Features
- Search definitions with phonetics and parts of speech.
- Persisted favorites and recents (local `SharedPreferences`).
- Friendly timestamps for recents.
- Google Fonts styling.

## Backend (Express)
- Location: `server/`
- Install and run:
	```sh
	cd server
	npm install
	npm start  # http://localhost:3000
	```
- Endpoints:
	- `GET /api/health`
	- `GET /api/define?word=<term>`

## Frontend (Flutter)
- Install deps and run:
	```sh
	flutter pub get
	flutter run
	```
- Android emulator uses `10.0.2.2:3000`; web/desktop/iOS use `localhost:3000` automatically.

## Tech Stack
- Flutter, Dart
- Express, Node.js, Axios
- dictionaryapi.dev

## Project Layout
- `lib/` Flutter app code
- `lib/services/api_service.dart` backend client
- `lib/word_models.dart` models for responses
- `lib/favorites_data.dart` persistence for favorites/recents
- `server/` Express proxy

## Notes
- Translations are not included; only definitions from `dictionaryapi.dev`.
- Recents capped at 30 entries.
