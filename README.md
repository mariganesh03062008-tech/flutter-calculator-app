# Flutter Calculator App 📱

A clean, fast, and modern mobile calculator application built using Flutter and Material 3.

## ✨ Features

- **Standard Arithmetic**: Addition (`+`), Subtraction (`-`), Multiplication (`×`), Division (`÷`).
- **Advanced Features**: Percentage calculations (`%`), sign handling (`-`), and decimals (`.`).
- **BODMAS / PEMDAS**: Proper operator precedence calculation (e.g., `2 + 3 × 4 = 14`).
- **Live Preview**: Dynamic calculation preview displays the evaluated value as you type.
- **Safety Handling**: Graceful error protection against division by zero and invalid syntax.
- **Dark & Light Mode**: Built-in toggle to switch between iOS-style Dark Theme and Light Theme.
- **Responsive Keypad**: Ergonomic 4x5 button matrix with subtle touch feedback and distinct color coding.

---

## 📁 Project Structure

```text
Mobile API/
├── lib/
│   ├── main.dart                      # Application entry point & theme setup
│   ├── screens/
│   │   └── calculator_screen.dart     # Calculator UI layout & state management
│   ├── widgets/
│   │   └── calc_button.dart           # Reusable styled calculator buttons
│   └── utils/
│       └── calculator_logic.dart      # Pure Dart arithmetic & BODMAS logic
├── test/
│   └── calculator_test.dart           # Unit tests for arithmetic & edge cases
├── pubspec.yaml                       # Flutter package configuration
└── README.md                          # Documentation & quick start guide
```

---

## 🚀 How to Run the App

### 1. Prerequisites
Make sure you have Flutter installed. If Flutter is not yet installed on your machine, download it from [flutter.dev](https://docs.flutter.dev/get-started/install/windows) or install via terminal:
```powershell
git clone https://github.com/flutter/flutter.git -b stable C:\flutter
```
Add `C:\flutter\bin` to your system environment `PATH`.

### 2. Install Dependencies
Run in this directory:
```bash
flutter pub get
```

### 3. Run the App
Connect an Android device/emulator, or run on Chrome:
```bash
# To run on connected mobile device or emulator
flutter run

# Or to run quickly in Chrome browser
flutter run -d chrome
```

### 4. Run Unit Tests
```bash
flutter test
```

### 5. Build Release APK (Android)
```bash
flutter build apk --release
```
The generated APK will be in `build/app/outputs/flutter-apk/app-release.apk`.
