import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAyi28_j4w4iaWnFzFnP8tYtiftTNHju00',
    appId: '1:1033427642660:web:ab6cf66f2c664f9c86ebb1',
    messagingSenderId: '1033427642660',
    projectId: 'expense-tracker-app-cfc4a',
    authDomain: 'expense-tracker-app-cfc4a.firebaseapp.com',
    storageBucket: 'expense-tracker-app-cfc4a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-WfZPT7pG0eCRngjJDEgTH63dqCX5IQ8',
    appId: '1:1033427642660:android:2979e584669074ce86ebb1',
    messagingSenderId: '1033427642660',
    projectId: 'expense-tracker-app-cfc4a',
    storageBucket: 'expense-tracker-app-cfc4a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmCg6yX1E2hZV22j794Rl3xQ-frGoEDKM',
    appId: '1:1033427642660:ios:7ab088b7cab3d0a086ebb1',
    messagingSenderId: '1033427642660',
    projectId: 'expense-tracker-app-cfc4a',
    storageBucket: 'expense-tracker-app-cfc4a.appspot.com',
    androidClientId: '1033427642660-j6t6vdktcphokqoctnbv38didlqo0l1d.apps.googleusercontent.com',
    iosClientId: '1033427642660-3hc93efk0314qc05anmmb6efsnpff5c0.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmCg6yX1E2hZV22j794Rl3xQ-frGoEDKM',
    appId: '1:1033427642660:ios:1d0378ef0220fd1b86ebb1',
    messagingSenderId: '1033427642660',
    projectId: 'expense-tracker-app-cfc4a',
    storageBucket: 'expense-tracker-app-cfc4a.appspot.com',
    androidClientId: '1033427642660-j6t6vdktcphokqoctnbv38didlqo0l1d.apps.googleusercontent.com',
    iosClientId: '1033427642660-lu98os11nnv3jmqnjpaijjgsuhf5v15d.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp.RunnerTests',
  );
}
