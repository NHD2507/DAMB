// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB8C78v5_aWGSx_j9BLMzjQ88meQlclAeI',
    appId: '1:656661483319:web:f284904a1692554d56d4b2',
    messagingSenderId: '656661483319',
    projectId: 'buoi6-1576d',
    authDomain: 'buoi6-1576d.firebaseapp.com',
    databaseURL: 'https://buoi6-1576d-default-rtdb.firebaseio.com',
    storageBucket: 'buoi6-1576d.firebasestorage.app',
    measurementId: 'G-CCLWZPYYKY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvWm34uSfRn9SjfMkgS2sEuEyFIwg8WjQ',
    appId: '1:656661483319:android:163ffadfdbbc2fd056d4b2',
    messagingSenderId: '656661483319',
    projectId: 'buoi6-1576d',
    databaseURL: 'https://buoi6-1576d-default-rtdb.firebaseio.com',
    storageBucket: 'buoi6-1576d.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8C78v5_aWGSx_j9BLMzjQ88meQlclAeI',
    appId: '1:656661483319:web:3688468e617a0bf256d4b2',
    messagingSenderId: '656661483319',
    projectId: 'buoi6-1576d',
    authDomain: 'buoi6-1576d.firebaseapp.com',
    databaseURL: 'https://buoi6-1576d-default-rtdb.firebaseio.com',
    storageBucket: 'buoi6-1576d.firebasestorage.app',
    measurementId: 'G-9QFNQH0RKG',
  );
}
