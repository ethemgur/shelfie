package com.shelfie.shelfie

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        InstagramStoriesChannel(this).register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
