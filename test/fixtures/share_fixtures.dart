import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:shelfie/features/share/template_data.dart';

/// A deterministic 200×300 "cover": two colour bands and a circle.
Future<Uint8List> fakeCoverPng() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas
    ..drawRect(
      const Rect.fromLTWH(0, 0, 200, 150),
      Paint()..color = const Color(0xFF2E5E4E),
    )
    ..drawRect(
      const Rect.fromLTWH(0, 150, 200, 150),
      Paint()..color = const Color(0xFFE8C872),
    )
    ..drawCircle(
      const Offset(100, 150),
      50,
      Paint()..color = const Color(0xFFB8482E),
    );
  final image = await recorder.endRecording().toImage(200, 300);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return bytes!.buffer.asUint8List();
}

SessionTemplateData sessionFixture({
  ImageProvider? cover,
  String title = 'Pride and Prejudice',
  List<String> authors = const ['Jane Austen'],
  int fromPage = 120,
  int toPage = 162,
  int pageCount = 384,
  String? quote,
  int weeklyStreak = 4,
}) => SessionTemplateData(
  title: title,
  authors: authors,
  fromPage: fromPage,
  toPage: toPage,
  pageCount: pageCount,
  username: 'ethem',
  cover: cover,
  quote: quote,
  weeklyStreak: weeklyStreak,
);
