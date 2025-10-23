# Training-Plus

**Training-Plus** is a robust fitness app built with **Clean Architecture**, **Riverpod**, and a **Feature-Based Architecture**. It provides a complete training experience, allowing users to track their workouts, set custom goals, progress, and engage with the community. It also includes features for **nutrition tracking**, **deep linking**, **subscriptions**, and **map integration** to make the training journey more interactive and rewarding.

## Features

- **Training Types**: Different categories of workouts for users to choose from.
- **Admin Panel**: Admins can manage videos, challenges, and rewards.
- **User Workouts**: Users can complete workouts, track progress, and earn rewards.
- **Deep Linking**: Seamless navigation between sections of the app via deep links.
- **Custom Goals**: Users can set personal fitness goals and track their progress.
- **Progress Tracking**: Keeps track of workout completion, achievements, and overall progress.
- **Community**: Users can share progress, challenges, and interact with others.
- **Nutrition Tracking**: Log meals and track nutrition intake.
- **Subscription Management**: Handle premium subscriptions and content access.
- **Responsive UI**: Designed for a smooth user experience on multiple screen sizes.
- **Map Integration**: View workout locations or challenges with integrated maps.
- **Real-Time Feedback**: With refresh indicators and network status handling.

## Key Technologies & Packages Used

- **Flutter**: Cross-platform development framework.
- **Riverpod**: State management solution for scalable and efficient architecture.
- **Clean Architecture**: Used to maintain separation of concerns and modular design.
- **Deep Linking**: Using `app_links` for handling deep links within the app.
- **Camera & Video**: Integrated `camera`, `video_player`, and `image_picker` for media functionality.
- **Map Integration**: Utilizes `flutter_map`, `geolocator`, and `latlong2` for geolocation and map support.
- **Responsive Design**: `flutter_screenutil` for responsive UI based on screen size.
- **Progress Tracking**: Integrated `fl_chart` for visualizing progress, with **ratings and graphs**.

## Architecture Overview

The app is designed with **Clean Architecture**, **Riverpod**, and **Feature-Based Architecture** to ensure modular, testable, and scalable code.

### Core Layer
The **core layer** contains common services, providers, API calls, exception handling, base notifiers, and utilities shared across features.

- **Services**: API clients, local storage, and shared services.
- **Common Models**: Shared models used across different features.
- **Base Notifiers**: Manage and control state efficiently.
- **Utils**: Shared utilities for notifications, shared preferences, deep linking, etc.

**Directory Structure**:

```plaintext
lib/
│
├── core/                           # Core services, providers, and common models
│   ├── services/                   # API, local storage, and service-related code
│   │   ├── api/                    # API clients and services
│   │   │   ├── api_client.dart
│   │   │   ├── api_exception.dart
│   │   │   ├── api_service.dart
│   │   │   └── i_api_service.dart
│   │   └── localstorage/           # Local storage services
│   │       └── providers.dart
│   ├── common_models/              # Shared models used across features
│   │   ├── user_model.dart
│   │   └── training_model.dart
│   ├── base-notifiers/             # Base notifiers for state management
│   │   └── base_notifier.dart
│   └── utils/                      # Common utilities and helper classes
│       ├── notification_utils.dart
│       ├── shared_preference_utils.dart
│       └── deep_link_utils.dart
│
├── view/                           # UI code for various features
│   ├── authentication/             # Authentication-related UI
│   │   ├── after_signup_otp/       # OTP screen after signup
│   │   │   ├── after_signup_otp_controller.dart
│   │   │   ├── after_signup_otp_model.dart
│   │   │   ├── after_signup_otp_view.dart
│   │   ├── create_new_password/   # Create new password feature
│   │   ├── forget_password/       # Forget password UI
│   │   └── ...
│   ├── community/                  # Community-related UI
│   ├── home/                       # Home page UI
│   ├── intro_and_onboarding/       # Onboarding UI
│   ├── notification/               # Notifications UI
│   ├── personalization/            # Personalization-related UI
│   ├── profile/                    # Profile-related UI
│   └── training/                   # Training-related UI
│
└── widgets/                        # Reusable common widgets across features
│   ├── common_text.dart            # Reusable text widget
│   ├── common_textfield.dart       # Reusable text field widget
│   └── custom_button.dart          # Custom button widget
│  
└── main.dart
```
## Getting Started

### Prerequisites

Make sure you have the following installed:

- **Flutter SDK**
- **A code editor** (e.g., VS Code, Android Studio)
- **Android/iOS emulator** or a **physical device** for testing.

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/Training-Plus.git
   cd Training-Plus
   flutter pub get
   flutter run

## Git Commit Practices

Follow the **Conventional Commit** style for commit messages:

- `feat(auth): Add authentication feature`
- `refactor(home): Refactor home page for better UI`
- `fix(training): Fix bug in workout video playback`
- `docs: Update README or add new comments`
- `test: Add or update tests for functionality`



