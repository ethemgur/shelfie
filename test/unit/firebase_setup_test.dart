import 'package:flutter_test/flutter_test.dart';
import 'package:shelfie/app/firebase_setup.dart';

void main() {
  test('reads a registered Web app config from Hosting init.json', () {
    final options = optionsFromHostingConfig({
      'apiKey': 'AIzaSyExample',
      'appId': '1:123456789:web:abcdef',
      'authDomain': 'shelfie-app.firebaseapp.com',
      'messagingSenderId': '123456789',
      'projectId': 'shelfie-app',
      'storageBucket': 'shelfie-app.firebasestorage.app',
    })!;
    expect(options.projectId, 'shelfie-app');
    expect(options.appId, '1:123456789:web:abcdef');
    expect(options.storageBucket, 'shelfie-app.firebasestorage.app');
    expect(options.authDomain, 'shelfie-app.firebaseapp.com');
  });

  test('is null without a registered Web app (no appId)', () {
    expect(
      optionsFromHostingConfig({
        'apiKey': 'fake-api-key',
        'projectId': 'demo-shelfie',
      }),
      isNull,
    );
  });
}
