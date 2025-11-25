# Application Functionality Documentation

This document explains how the SolveIt application functions, from startup to feature implementation, using the Authentication feature as a practical example.

## Application Startup Flow

### 1. Main Entry Point (`lib/main.dart`)
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CoreInjectionContainer.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ...authViewmodels,
        // Other feature viewmodels
      ],
      child: const MyApp(),
    ),
  );
}
```

The application startup process:
1. Initialize Flutter bindings
2. Set up dependency injection
3. Register view models
4. Initialize the app with providers

### 2. Dependency Injection (`lib/core/injections/`)
```dart
class CoreInjectionContainer {
  static Future<void> initialize() async {
    // Register core services
    GetIt.instance.registerSingleton<GoRouter>(router);
    
    // Register feature-specific dependencies
    await AuthInjectionContainer.initialize();
    // Other feature containers
  }
}
```

## Feature Implementation (Authentication Example)

### 1. Data Layer (`lib/features/authentication/data/`)

#### API Implementation (`auth_api.dart`)
```dart
class AuthApi {
  final Dio _dio;
  
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }
  
  // Other API methods
}
```

#### Data Models
```dart
class AuthResponse {
  final String token;
  final User user;
  
  AuthResponse.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        user = User.fromJson(json['user']);
}
```

### 2. Domain Layer (`lib/features/authentication/domain/`)

#### Service Implementation (`auth_service.dart`)
```dart
class AuthService {
  final AuthApi _api;
  final SecureStorage _storage;
  
  Future<User> login(String email, String password) async {
    final response = await _api.login(LoginRequest(email, password));
    await _storage.saveToken(response.token);
    return response.user;
  }
  
  // Other business logic
}
```

### 3. Presentation Layer (`lib/features/authentication/presentation/`)

#### ViewModel (`viewmodel/auth_viewmodel.dart`)
```dart
class AuthViewModel extends ChangeNotifier {
  final AuthService _service;
  AuthState _state = AuthState.initial();
  
  Future<void> login(String email, String password) async {
    _state = AuthState.loading();
    notifyListeners();
    
    try {
      final user = await _service.login(email, password);
      _state = AuthState.authenticated(user);
    } catch (e) {
      _state = AuthState.error(e.toString());
    }
    
    notifyListeners();
  }
}
```

This is the desired flow to be implemented
#### UI Implementation (`pages/login_screen.dart`)
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: viewModel.state.when(
            initial: () => LoginForm(),
            loading: () => LoadingIndicator(),
            authenticated: (user) => HomeScreen(),
            error: (message) => ErrorView(message),
          ),
        );
      },
    );
  }
}
```

## State Management Flow

1. **User Action**
   - User enters credentials
   - Taps login button

2. **ViewModel Processing**
   - ViewModel receives action
   - Updates state to loading
   - Calls service method

3. **Service Layer**
   - Service processes request
   - Calls API
   - Handles response

4. **State Update**
   - ViewModel receives result
   - Updates state
   - Notifies listeners

5. **UI Update**
   - Consumer rebuilds
   - Shows appropriate UI

## API Integration

### Request Flow
1. UI triggers action
2. ViewModel processes
3. Service makes API call
4. Response is handled
5. State is updated
6. UI reflects changes

### Error Handling
```dart
try {
  final response = await _api.login(request);
  return response;
} catch (e) {
  if (e is DioError) {
    throw AuthException(e.response?.data['message']);
  }
  throw AuthException('Unknown error occurred');
}
```

## Navigation

### Route Definition
```dart
final authRoutes = [
  GoRoute(
    path: '/login',
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    builder: (context, state) => RegisterScreen(),
  ),
];
```

### Navigation Usage
```dart
context.go('/login');  // Navigate to login
context.go('/home');   // Navigate to home
```

## Dependency Injection

### Feature Container
```dart
class AuthInjectionContainer {
  static Future<void> initialize() async {
    // Register API
    GetIt.instance.registerLazySingleton<AuthApi>(
      () => AuthApi(GetIt.instance<Dio>()),
    );
    
    // Register Service
    GetIt.instance.registerLazySingleton<AuthService>(
      () => AuthService(
        GetIt.instance<AuthApi>(),
        GetIt.instance<SecureStorage>(),
      ),
    );
    
    // Register ViewModel
    GetIt.instance.registerFactory<AuthViewModel>(
      () => AuthViewModel(GetIt.instance<AuthService>()),
    );
  }
}
```

## Testing

### ViewModel Test
```dart
void main() {
  group('AuthViewModel', () {
    late AuthViewModel viewModel;
    late MockAuthService mockService;
    
    setUp(() {
      mockService = MockAuthService();
      viewModel = AuthViewModel(mockService);
    });
    
    test('login success', () async {
      when(mockService.login(any, any))
          .thenAnswer((_) async => mockUser);
      
      await viewModel.login('email', 'password');
      
      expect(viewModel.state, isA<Authenticated>());
    });
  });
}
```

## Best Practices

1. **Separation of Concerns**
   - Data layer handles API calls
   - Domain layer contains business logic
   - Presentation layer manages UI

2. **State Management**
   - Use immutable state
   - Handle all possible states
   - Provide clear state transitions

3. **Error Handling**
   - Catch and handle all errors
   - Provide user-friendly messages
   - Log errors for debugging

4. **Testing**
   - Test each layer independently
   - Mock dependencies
   - Test all state transitions

5. **Code Organization**
   - Follow feature-first structure
   - Keep related code together
   - Use clear naming conventions 