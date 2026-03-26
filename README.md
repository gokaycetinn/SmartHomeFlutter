# Smart Home Flutter

Flutter-based smart home control application with room-based device management, gesture-action mappings, event polling, and Raspberry Pi connection settings.

## Features

- Dashboard with animated sections and device quick controls
- Room filtering and room detail screen
- Device on/off toggle with optimistic UI update
- Gesture to action mapping editor (bottom sheet)
- Last detected event polling (demo flow)
- Raspberry Pi IP configuration with local persistence
- Mock API layer and real API adapter support

## Tech Stack

- Flutter, Dart
- State management: provider
- Networking: http
- Local storage: shared_preferences
- UI utilities: animate_do, flutter_svg, google_fonts

## Project Structure

```
lib/
	models/
		device_model.dart
		event_model.dart
		mapping_model.dart
	providers/
		home_provider.dart
	screens/
		dashboard_screen.dart
		room_screen.dart
		mapping_screen.dart
		settings_screen.dart
	services/
		api_service.dart
	widgets/
		device_card.dart
	main.dart
```

## How It Works

- `HomeProvider` is the app state source for devices, mappings, loading state, and last event.
- `MockApiService` is the default data source for development/demo.
- `RealApiService` is available for backend integration with REST endpoints.
- UI screens read and mutate state through provider methods.

## API Contract (RealApiService)

- `GET /devices`
- `POST /device/{id}/action` with body: `{ "command": "ON" | "OFF" }`
- `POST /device/{id}/value` with body: `{ "value": number }`
- `GET /mappings`
- `POST /mapping`
- `GET /event/last`

## Getting Started

1. Install Flutter SDK (stable channel).
2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Notes

- Screens and provider architecture for the smart home flow are implemented under `lib/screens` and `lib/providers`.
- If you want to connect to a real backend, switch provider service initialization from `MockApiService` to `RealApiService` and set your base URL.

## Screenshots

<p>
	<img src="assets/screenshots/1.png" alt="Dashboard" width="190" />
	<img src="assets/screenshots/3.png" alt="Device Mapping" width="190" />
	<img src="assets/screenshots/4.png" alt="Settings" width="190" />
</p>
<p>
	<img src="assets/screenshots/2.png" alt="Rooms" width="190" />
	<img src="assets/screenshots/5.png" alt="Events" width="190" />
</p>
