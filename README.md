# Quranic Tool Box

A comprehensive Flutter application designed to provide various tools and features for Quranic studies and learning.

## Features

-   Quran reading and recitation
-   Audio recording and playback capabilities
-   Progress tracking
-   User authentication
-   Cloud storage integration
-   Custom Quranic fonts support
-   Responsive design for multiple platforms

## Getting Started

### Prerequisites

-   Flutter SDK (version >=2.18.2)
-   Dart SDK
-   Firebase account (for backend services)
-   Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:

```bash
git clone [repository-url]
```

2. Navigate to the project directory:

```bash
cd quranic_tool_box
```

3. Install dependencies:

```bash
flutter pub get
```

4. Configure Firebase:

    - Create a new Firebase project
    - Add your Android/iOS/Web app to the Firebase project
    - Download and add the configuration files
    - Enable Authentication, Firestore, and Storage services

5. Run the app:

```bash
flutter run
```

## Dependencies

The project uses several key packages:

-   **State Management**: Provider (^6.0.5)
-   **Firebase Services**:
    -   Firebase Core (^2.3.0)
    -   Cloud Firestore (^4.1.0)
    -   Firebase Auth (^4.1.5)
    -   Firebase Storage (^11.0.6)
-   **UI Components**:
    -   Flutter Animation Progress Bar (^2.3.1)
    -   Settings UI (^2.0.2)
    -   Auto Size Text (^3.0.0)
    -   Introduction Screen (^3.0.2)
-   **Audio Handling**:
    -   Record (^4.4.3)
    -   Flutter Sound (^9.2.13)
-   **Utilities**:
    -   HTTP (^0.13.5)
    -   Permission Handler (^10.3.0)
    -   Path Provider (^2.0.11)
    -   Flutter HTML (^2.2.1)
    -   Shared Preferences (^2.1.2)

## Project Structure

```
lib/
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
└── macos/
```

## Custom Fonts

The application includes several custom Quranic fonts:

-   Al Majeed Quranic
-   Al Qalam Quran
-   Besmellah Normal
-   Quran Font 1 & 2
-   And more...

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
