import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:preview_lib/preview_arguments.dart';

class PreviewController {
  static const MethodChannel _methodChannel =
  MethodChannel('com.demo.preview_camera/method');

  /// A notifier that provides several arguments
  final ValueNotifier<PreviewArguments?> startArguments =
  ValueNotifier(null);

  void start() async {
    final int state = await _methodChannel.invokeMethod('state') ?? 0;
    if (state == 0) {
      await _methodChannel.invokeMethod('request') as bool? ?? false;
    }

    Map<String, dynamic>? startResult = {};

    try {
      startResult =
      await _methodChannel.invokeMapMethod<String, dynamic>('start');
    } on PlatformException catch (error) {
      debugPrint('${error.code}: ${error.message}');
      return null;
    }

    if (startResult != null) {
      startArguments.value = PreviewArguments(
        textureId: startResult['textureId'] as int?,
        size: toSize(startResult['size'] as Map? ?? {}),
      );
    }
  }

  Size toSize(Map data) {
    final width = data['width'] as double;
    final height = data['height'] as double;
    return Size(width, height);
  }
}