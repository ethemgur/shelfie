import 'dart:io';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/env.dart';

enum InstagramShareOutcome { launched, fellBackToSystemShare }

/// Shares to Instagram Stories through the `share/instagram` platform
/// channel (see `MainActivity.kt` and `InstagramStoriesChannel.swift`).
/// Falls back to the system share sheet when Instagram isn't installed or no
/// Meta App ID is configured.
class InstagramStoriesShare {
  InstagramStoriesShare({
    this._channel = const MethodChannel('share/instagram'),
    this._metaAppId = Env.metaAppId,
    Future<void> Function(List<File> files)? systemShare,
  }) : _systemShare = systemShare ?? _shareViaSheet;

  final MethodChannel _channel;
  final String _metaAppId;
  final Future<void> Function(List<File> files) _systemShare;

  Future<bool> isAvailable() async {
    if (_metaAppId.isEmpty) return false;
    return await _channel.invokeMethod<bool>('isAvailable') ?? false;
  }

  /// Exactly one of [background] (full-screen story image) or [sticker]
  /// (transparent PNG over a gradient of [topColor] → [bottomColor]) is the
  /// main asset; passing both puts the sticker over the background.
  Future<InstagramShareOutcome> share({
    File? background,
    File? sticker,
    Color? topColor,
    Color? bottomColor,
  }) async {
    assert(background != null || sticker != null);
    if (await isAvailable()) {
      final launched = await _channel.invokeMethod<bool>('shareToStory', {
        'appId': _metaAppId,
        'backgroundPath': background?.path,
        'stickerPath': sticker?.path,
        'topColor': topColor == null ? null : _hex(topColor),
        'bottomColor': bottomColor == null ? null : _hex(bottomColor),
      });
      if (launched ?? false) return InstagramShareOutcome.launched;
    }
    await _systemShare([?background, ?sticker]);
    return InstagramShareOutcome.fellBackToSystemShare;
  }

  static String _hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  static Future<void> _shareViaSheet(List<File> files) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [for (final f in files) XFile(f.path, mimeType: 'image/png')],
      ),
    );
  }
}
