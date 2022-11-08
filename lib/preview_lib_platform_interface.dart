import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'preview_lib_method_channel.dart';

abstract class PreviewLibPlatform extends PlatformInterface {
  /// Constructs a PreviewLibPlatform.
  PreviewLibPlatform() : super(token: _token);

  static final Object _token = Object();

  static PreviewLibPlatform _instance = MethodChannelPreviewLib();

  /// The default instance of [PreviewLibPlatform] to use.
  ///
  /// Defaults to [MethodChannelPreviewLib].
  static PreviewLibPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PreviewLibPlatform] when
  /// they register themselves.
  static set instance(PreviewLibPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
