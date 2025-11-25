# Application Flow Diagrams

## 1. Application Startup Flow

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  main.dart      │────▶│  CoreInjection      │────▶│  Feature Injection  │
│                 │     │  Container          │     │  Containers         │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        ▼                         ▼                           ▼
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  MultiProvider  │◀────│  Core Services      │◀────│  Feature Services   │
│                 │     │  Registration       │     │  Registration       │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │
        │
        ▼
┌─────────────────┐
│                 │
│  MyApp          │
│                 │
└─────────────────┘
```

## 2. Authentication Feature Flow

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  LoginScreen    │────▶│  AuthViewModel      │────▶│  AuthService        │
│  (UI Layer)     │     │  (Presentation)     │     │  (Domain)           │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        │                         ▼                           ▼
        │                 ┌─────────────────┐     ┌─────────────────────┐
        │                 │                 │     │                     │
        │                 │  State Update   │     │  AuthApi            │
        │                 │                 │     │  (Data)             │
        │                 └─────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        └─────────────────────────┘                           │
                                                             │
                                                             ▼
                                                    ┌─────────────────────┐
                                                    │                     │
                                                    │  API Response       │
                                                    │                     │
                                                    └─────────────────────┘
```

## 3. State Management Flow

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  Initial State  │────▶│  Loading State      │────▶│  Success/Error      │
│                 │     │                     │     │  State              │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        ▼                         ▼                           ▼
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  UI: Login Form │     │  UI: Loading        │     │  UI: Success/Error  │
│                 │     │  Indicator          │     │  View               │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
```

## 4. Dependency Injection Flow

```
┌─────────────────┐
│                 │
│  GetIt          │
│  Container      │
│                 │
└─────────────────┘
        │
        │
        ▼
┌─────────────────────────────────────────────────┐
│                                                 │
│  ┌─────────────┐    ┌─────────────┐            │
│  │             │    │             │            │
│  │  AuthApi    │    │  AuthService│            │
│  │             │    │             │            │
│  └─────────────┘    └─────────────┘            │
│         │                 │                     │
│         │                 │                     │
│         ▼                 ▼                     │
│  ┌─────────────┐    ┌─────────────┐            │
│  │             │    │             │            │
│  │  ViewModel  │    │  UI Widgets │            │
│  │             │    │             │            │
│  └─────────────┘    └─────────────┘            │
│                                                 │
└─────────────────────────────────────────────────┘
```

## 5. API Request Flow

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  User Action    │────▶│  ViewModel          │────▶│  Service            │
│                 │     │  Processing         │     │  Processing         │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        │                         ▼                           ▼
        │                 ┌─────────────────┐     ┌─────────────────────┐
        │                 │                 │     │                     │
        │                 │  State Update   │     │  API Request        │
        │                 │                 │     │                     │
        │                 └─────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        └─────────────────────────┘                           │
                                                             │
                                                             ▼
                                                    ┌─────────────────────┐
                                                    │                     │
                                                    │  API Response       │
                                                    │                     │
                                                    └─────────────────────┘
```

## 6. Error Handling Flow

```
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  API Error      │────▶│  Service Error      │────▶│  ViewModel Error    │
│                 │     │  Handling           │     │  Handling           │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        ▼                         ▼                           ▼
┌─────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│                 │     │                     │     │                     │
│  Error Response │     │  Error Translation  │     │  Error State        │
│                 │     │                     │     │                     │
└─────────────────┘     └─────────────────────┘     └─────────────────────┘
        │                         │                           │
        │                         │                           │
        └─────────────────────────┴───────────────────────────┘
                                                             │
                                                             ▼
                                                    ┌─────────────────────┐
                                                    │                     │
                                                    │  Error UI           │
                                                    │  Display            │
                                                    └─────────────────────┘
```

## Legend

- `───▶` : Flow direction
- `│` : Connection
- `┌─┐` : Component/Module
- `└─┘` : Component/Module end

## Notes

1. **Application Startup**
   - Shows the initialization sequence
   - Demonstrates dependency injection setup
   - Illustrates service registration

2. **Authentication Flow**
   - Shows the complete authentication process
   - Illustrates layer interaction
   - Demonstrates state management

3. **State Management**
   - Shows state transitions
   - Illustrates UI updates
   - Demonstrates state handling

4. **Dependency Injection**
   - Shows service registration
   - Illustrates dependency relationships
   - Demonstrates component connections

5. **API Request Flow**
   - Shows request processing
   - Illustrates data flow
   - Demonstrates response handling

6. **Error Handling**
   - Shows error propagation
   - Illustrates error translation
   - Demonstrates error display 