import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('DefaultFirebaseOptions not configured for this platform.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDummyKeyForWebTesting',
    appId: '1:123456789:web:abcdef1234567890',
    messagingSenderId: '123456789',
    projectId: 'test-project',
    authDomain: 'test-project.firebaseapp.com',
    storageBucket: 'test-project.appspot.com',
    measurementId: 'G-DUMMYMEASUREMENTID',
  );
}

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
