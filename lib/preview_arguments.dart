import 'package:flutter/material.dart';

/// Camera args for [CameraView].
class PreviewArguments {
  /// The texture id.
  final int? textureId;

  /// Size of the texture.
  final Size size;

  /// Create a [PreviewArguments].
  PreviewArguments({
    this.textureId,
    required this.size,
  });
}