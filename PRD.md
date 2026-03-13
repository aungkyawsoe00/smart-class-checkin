# Product Requirement Document (PRD)
## Smart Class Check-in & Learning Reflection App

---

## 1. Problem Statement

Universities struggle to verify student attendance and engagement in classroom settings. Traditional sign-in sheets lack verification, and instructors have limited insight into student preparedness and learning outcomes. This system provides:

- **Verified attendance** through GPS location and QR code validation
- **Learning reflection** to gauge student preparation and understanding  
- **Instructor insights** into class participation and student sentiment

---

## 2. Target Users

- **Primary**: University students (undergraduate & graduate)
- **Secondary**: Instructors/Professors (dashboard view)
- **Tertiary**: Academic administrators (analytics)

---

## 3. Feature List

### 3.1 Student Features

**Home Dashboard**
- View check-in/check-out summary
- Quick access to check-in and check-out workflows
- Refresh dashboard to see latest data

**Check-in (Before Class)**
- Capture current GPS location with timestamp
- Scan class QR code for verification
- Fill reflection form:
  - Previous class topic (recall)
  - Expected topic (preparation)
  - Mood before class (1-5 scale)
- Submit and save data

**Check-out (After Class)**
- Scan class QR code again
- Capture exit GPS location
- Fill completion form:
  - What was learned today
  - Feedback on class/instructor
- Submit and save data

**Data Persistence**
- Save all check-in/check-out records locally
- Sync with Firebase (future enhancement)

### 3.2 System Features
- Local data storage (SQLite/SharedPreferences)
- Firebase Firestore integration (for production)
- QR code scanning capability
- GPS geolocation services

---

## 4. User Flow

```
┌─────────────────────────────────────────────────────────┐
│                    HOME SCREEN                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Session Summary                                 │  │
│  │  ✓ Check-ins: 5 | ✓ Check-outs: 4              │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌─────────────────────┬──────────────────────────┐   │
│  │  CHECK IN BUTTON    │  CHECK OUT BUTTON       │   │
│  │  (Before Class)     │  (After Class)          │   │
│  └─────────────────────┴──────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
        ↓                      ↓
    [CHECK-IN FLOW]      [CHECK-OUT FLOW]
        ↓                      ↓
  1. Capture GPS        1. Capture GPS
  2. Scan QR Code       2. Scan QR Code
  3. Fill Form          3. Fill Form
     - Previous Topic      - What Learned
     - Expected Topic      - Feedback
     - Mood Scale
  4. Submit & Save      4. Submit & Save
        ↓                      ↓
    [SAVED LOCALLY]       [SAVED LOCALLY]
        ↓                      ↓
    ← RETURN TO HOME SCREEN ←
```

---

## 5. Data Fields

### 5.1 Check-in Record
```
{
  id: UUID,
  qrCode: String,
  latitude: Double,
  longitude: Double,
  timestamp: DateTime,
  previousTopic: String,
  expectedTopic: String,
  mood: Int (1-5),
  createdAt: DateTime,
  syncedAt: DateTime (optional)
}
```

### 5.2 Check-out Record
```
{
  id: UUID,
  qrCode: String,
  latitude: Double,
  longitude: Double,
  timestamp: DateTime,
  learnedToday: String,
  feedback: String,
  createdAt: DateTime,
  syncedAt: DateTime (optional)
}
```

---

## 6. Tech Stack

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **UI Library**: Material Design 3

### Backend & Storage
- **Local Storage**: SharedPreferences (MVP), SQLite (future)
- **Cloud Database**: Firebase Firestore
- **Authentication**: Firebase Auth (future)
- **Hosting**: Firebase Hosting

### Libraries
- `geolocator`: GPS location retrieval
- `mobile_scanner`: QR code scanning
- `firebase_core`: Firebase initialization
- `cloud_firestore`: Cloud data storage
- `shared_preferences`: Local data persistence

---

## 7. Key Workflows

### 7.1 Check-in Workflow
1. Student clicks "Check In" on home screen
2. System requests location permission (if needed)
3. GPS coordinates + timestamp captured
4. Student scans class QR code
5. Student fills reflection form with validation
6. Data saved to local storage (and Firestore in production)
7. Success notification shown
8. Return to home screen with updated count

### 7.2 Check-out Workflow
1. Student clicks "Check Out" on home screen
2. System requests location permission
3. GPS coordinates + timestamp captured
4. Student scans class QR code again
5. Student fills completion feedback form
6. Data saved to local storage (and Firestore in production)
7. Success notification shown
8. Return to home screen with updated count

---

## 8. Success Criteria

### MVP (Minimum Viable Product)
- ✅ Home screen displays summary
- ✅ Check-in and check-out workflows functional
- ✅ GPS location captured
- ✅ QR code scanning working
- ✅ Form validation implemented
- ✅ Data persists in local storage
- ✅ Web version accessible (at least one platform)

### Future Enhancements
- Firebase Firestore sync for cloud backup
- Instructor dashboard to view class analytics
- Real-time attendance verification
- Mobile app versions (iOS/Android)
- Push notifications for reminders
- User authentication system

---

## 9. Constraints & Assumptions

### Constraints
- GPS accuracy: ±20 meters (acceptable for classroom verification)
- Web version uses local storage only (no Firebase on web for MVP)
- Single-session app (no user authentication for MVP)

### Assumptions
- Class QR codes are static and posted in classroom
- Students have location services enabled
- Network connectivity not required for MVP (local storage)
- Students are using modern browsers (Chrome, Edge, Firefox)

---

## 10. Success Metrics

| Metric | Target |
|--------|--------|
| App Load Time | < 3 seconds |
| Form Submission | < 2 seconds |
| Data Persistence | 100% reliable |
| GPS Accuracy | ±20 meters |
| QR Scan Success | 95%+ first attempt |

---

**Document Version**: 1.0  
**Last Updated**: March 13, 2026  
**Status**: Approved for MVP Development
