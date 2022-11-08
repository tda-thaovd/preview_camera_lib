
import 'preview_lib_platform_interface.dart';

class PreviewLib {
  Future<String?> getPlatformVersion() {
    return PreviewLibPlatform.instance.getPlatformVersion();
  }
}
