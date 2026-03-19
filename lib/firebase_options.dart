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
    apiKey: 'AIzaSyCQeYLNgogMAJzEgBjuLrpNtz5q2CLb0_A',
    appId: '1:66112935223:web:b7b18067d0062c50b836b2',
    messagingSenderId: '66112935223',
    projectId: 'rms-monitoring-platform',
    authDomain: 'rms-monitoring-platform.firebaseapp.com',
    storageBucket: 'rms-monitoring-platform.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDGRJy6Z7xsjqvTOLXR_Mr0nJKXmaEda4',
    appId: '1:66112935223:android:096b2bd16ae0b73bb836b2',
    messagingSenderId: '66112935223',
    projectId: 'rms-monitoring-platform',
    storageBucket: 'rms-monitoring-platform.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvpexhFCpHadya-G6MLlEl9HBBN0EfFAU',
    appId: '1:66112935223:ios:de15678e9fe1a84bb836b2',
    messagingSenderId: '66112935223',
    projectId: 'rms-monitoring-platform',
    storageBucket: 'rms-monitoring-platform.firebasestorage.app',
    iosBundleId: 'com.example.monitoringApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvpexhFCpHadya-G6MLlEl9HBBN0EfFAU',
    appId: '1:66112935223:ios:de15678e9fe1a84bb836b2',
    messagingSenderId: '66112935223',
    projectId: 'rms-monitoring-platform',
    storageBucket: 'rms-monitoring-platform.firebasestorage.app',
    iosBundleId: 'com.example.monitoringApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCQeYLNgogMAJzEgBjuLrpNtz5q2CLb0_A',
    appId: '1:66112935223:web:01fc6ada2891ba5ab836b2',
    messagingSenderId: '66112935223',
    projectId: 'rms-monitoring-platform',
    authDomain: 'rms-monitoring-platform.firebaseapp.com',
    storageBucket: 'rms-monitoring-platform.firebasestorage.app',
  );

}