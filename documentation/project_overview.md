# Project Overview Documentation

## Project Structure

```
solveit-new-app/
├── lib/
│   ├── core/                 # Core functionality
│   │   ├── injections/      # Dependency injection
│   │   ├── network/         # Network handling
│   │   └── widgets/         # Core widgets
│   ├── features/            # Feature modules
│   ├── utils/               # Utilities
│   │   ├── assets/         # Asset management
│   │   ├── extensions/     # Extension methods
│   │   ├── navigation/     # Navigation utilities
│   │   ├── theme/          # Theme system
│   │   └── utils/          # General utilities
│   ├── l10n/               # Localization
│   └── jsons/              # JSON data
├── assets/                  # Static assets
├── test/                    # Test files
└── documentation/           # Project documentation
```

## Major Dependencies

### Core Dependencies
- **flutter_screenutil**: For responsive design
- **provider**: For state management
- **go_router**: For navigation
- **flutter_svg**: For SVG assets
- **country_picker**: For country selection
- **upgrader**: For app updates

### Development Dependencies
- **flutter_test**: For testing
- **flutter_lints**: For code quality
- **build_runner**: For code generation

## Environment Setup

### Prerequisites
1. Flutter SDK
2. Dart SDK
3. Android Studio / Xcode
4. Git

### Setup Steps
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure environment:
   - Set up Firebase configuration
   - Configure localization
   - Set up development environment

### Development Environment
- Flutter version: Latest stable
- Dart version: Latest stable
- IDE: Android Studio / VS Code
- Platform: iOS, Android, Web

## Build and Run

### Development
```bash
flutter run
```

### Production
```bash
flutter build apk
flutter build ios
flutter build web
```

## Project Configuration

### Firebase Setup
- Firebase configuration in `firebase_options.dart`
- Firebase rules in `firebase.json`

### Localization
- Configuration in `l10n.yaml`
- Localization files in `lib/l10n/`

### CI/CD
- GitHub Actions configuration in `.github/`
- Codemagic configuration in `codemagic.yaml`

## Development Guidelines

### Code Style
- Follow Flutter style guide
- Use provided lint rules
- Follow project structure

### Git Workflow
- Feature branches
- Pull request reviews
- Commit message format

### Testing
- Unit tests
- Widget tests
- Integration tests

## Deployment

### Android
- Configure signing
- Update version
- Build release

### iOS
- Configure certificates
- Update version
- Build release

### Web
- Configure hosting
- Build and deploy 