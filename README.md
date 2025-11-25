# Solveit

A comprehensive Forum and service management platform built with Flutter.

## 🚀 Project Overview

Solveit is a feature-rich Flutter application that provides service management solutions. The application is built using modern Flutter development practices and follows a feature-first architecture.

### 🌟 Key Features

- User Authentication and Authorization
- Admin Dashboard
- Forum System
- Messaging System
- Market Place
- Service Management
- School Management
- Post Management
- Real-time Updates
- Multi-language Support (English, Greek)
- Location-based Services
- File Management (Images, Videos, PDFs)

## 🛠 Technical Stack

### Core Technologies
- **Framework**: Flutter (SDK >=3.4.3)
- **State Management**: Provider + GetIt
- **Navigation**: GoRouter
- **Backend Integration**: Firebase + REST APIs
- **Localization**: Flutter Localizations
- **Dependency Injection**: GetIt

### Key Dependencies
- **UI Components**:
  - `flutter_screenutil`: Responsive UI
  - `google_fonts`: Typography
  - `flutter_svg`: SVG support
  - `cached_network_image`: Image caching
  - `shimmer`: Loading effects

- **State & Data Management**:
  - `provider`: State management
  - `get_it`: Dependency injection
  - `dio`: HTTP client
  - `shared_preferences`: Local storage

- **Features**:
  - `firebase_core`: Firebase integration
  - `google_maps_flutter`: Maps integration
  - `socket_io_client`: Real-time communication
  - `image_picker`: Media handling
  - `pdfx`: PDF handling

## 📁 Project Structure

```
lib/
├── core/           # Core functionality and utilities
├── features/       # Feature modules
│   ├── admin/     # Admin functionality
│   ├── auth/      # Authentication
│   ├── forum/     # Forum system
│   ├── home/      # Home screen
│   ├── market/    # Marketplace
│   ├── messages/  # Messaging system
│   ├── posts/     # Post management
│   ├── school/    # School management
│   └── service/   # Service management
├── utils/         # Utility functions and helpers
├── l10n/          # Localization files
└── jsons/         # JSON data files
```

## 📚 Documentation

Comprehensive documentation for this project is available in the [documentation folder](./documentation/README.md).

### Documentation Contents:
- **Project Overview**: Project structure, dependencies, and setup
- **Architecture**: Clean architecture implementation and system design
- **UI/UX**: Theme system, component library, and design patterns
- **Application Functionality**: Core features and business logic
- **Application Flow**: User journeys and screen transitions
- **Testing**: Testing strategies and best practices
- **API Documentation**: API endpoints and integration details
- **Code Guidelines**: Code conventions and design patterns
- **Feature Documentation**: Detailed documentation for each feature

For developers new to the project, starting with the [Project Overview](./documentation/project_overview.md) and [Architecture](./documentation/architecture.md) documentation is recommended.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3)
- Dart SDK
- Android Studio / VS Code
- Firebase account
- Google Maps API key

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)
   - Configure Firebase in the project

4. Configure environment variables:
   - Set up your API keys
   - Configure Google Maps API key

5. Run the app:
```bash
flutter run
```

## 🔧 Development Guidelines

### Code Style
- Follow the Flutter style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### State Management
- Use Provider for UI state
- Use GetIt for dependency injection
- Keep business logic in viewmodels

### Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Maintain good test coverage

## 📱 Platform Support

- Android
- iOS
- Web (Admin panel)

## 🔐 Security

- Secure API communication
- Firebase Authentication
- Secure storage for sensitive data
- Permission handling for device features

## 🌐 Internationalization

The app supports multiple languages:
- English (en_US)
- Greek (el)

## 📈 Performance

- Image optimization
- Lazy loading
- Efficient state management
- Proper memory management

## 🔄 CI/CD

The project uses Codemagic for CI/CD with configurations in `codemagic.yaml`.


