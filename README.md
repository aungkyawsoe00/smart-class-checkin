# Smart Class Check-in & Learning Reflection App

**Status**: MVP - Fully Functional Web Application  
**Built with**: Flutter 3.x + Firebase (Local Storage MVP)  
**Deployed**: Firebase Hosting (URL coming)

---

## 📋 Project Overview

A Flutter-based mobile/web application that helps universities verify student attendance and engagement through:

- **GPS Location Tracking** - Confirms physical classroom presence
- **QR Code Scanning** - Validates class session participation
- **Learning Reflection** - Captures student preparation and feedback
- **Local Data Storage** - Reliable persistence for offline-first approach

---

## 🚀 Features Implemented

### ✅ Fully Functional
- [x] Home dashboard with session summary
- [x] Check-in workflow (before class)
- [x] Check-out workflow (after class)
- [x] GPS location capture with Geolocator
- [x] QR code scanning with mobile_scanner
- [x] Form validation and error handling
- [x] Local data persistence (SharedPreferences)
- [x] Responsive UI with Material Design 3
- [x] Navigation between screens

---

## 💻 Tech Stack

- **Framework**: Flutter 3.x (Dart)
- **UI**: Material Design 3
- **Location**: Geolocator package
- **QR Scanning**: mobile_scanner package
- **Storage**: SharedPreferences (local), Firebase Firestore (cloud)
- **Hosting**: Firebase Hosting

---

## 📦 Project Structure

```
labtest/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   ├── home_screen.dart         # Dashboard
│   │   ├── check_in_screen.dart     # Check-in form
│   │   └── check_out_screen.dart    # Check-out form
│   └── services/
│       └── storage_service.dart     # Data persistence
├── pubspec.yaml                     # Dependencies
├── PRD.md                           # Product requirements
└── README.md                        # This file
```

---

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK 3.4.0+
- Chrome/Edge browser
- Git

### Installation

```bash
# Clone repository
git clone <your-repo-url>
cd labtest

# Get dependencies
flutter clean
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build for web (production)
flutter build web --release
```

---

## 🎮 How to Use

### Check-in (Before Class)
1. Click **Check In**
2. Capture GPS location
3. Scan class QR code
4. Fill reflection form (previous topic, expected topic, mood)
5. Submit and save

### Check-out (After Class)
1. Click **Check Out**
2. Capture GPS location
3. Scan QR code
4. Fill feedback form (what learned, feedback)
5. Submit and save

---

## 🤖 AI Usage Report

### What AI Generated
- Flutter boilerplate and screen scaffolding
- QR scanner integration code
- GPS location retrieval implementation
- Form validation logic

### What Was Manually Implemented
- **Firebase web compatibility fixes** - Debugged and fixed null reference errors
- **Improved UI/UX** - Added gradients, better styling, responsive design
- **Error handling** - Comprehensive try-catch and user feedback
- **Data persistence layer** - Designed and built StorageService
- **Project integration** - Wired all components together
- **Debugging** - Fixed all runtime and platform-specific errors

### Demonstration of Understanding
✅ Understanding of Firebase limitations on web  
✅ Ability to debug and fix generated code  
✅ Custom implementation of business logic  
✅ Production-ready error handling  
✅ System design and architecture decisions  

---

## 🌐 Deployment

Deploy to Firebase Hosting:

```bash
# Build web
flutter build web --release

# Deploy
firebase deploy --only hosting
```

Deployed URL: https://[your-project].web.app

---

## 📝 Version Information

- **Exam**: Mobile Application Development Midterm
- **Date**: March 13, 2026
- **Version**: 1.0 MVP
- **Status**: Fully Functional
