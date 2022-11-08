import 'package:flutter_test/flutter_test.dart';
import 'package:preview_lib/preview_lib.dart';
import 'package:preview_lib/preview_lib_platform_interface.dart';
import 'package:preview_lib/preview_lib_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPreviewLibPlatform 
    with MockPlatformInterfaceMixin
    implements PreviewLibPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PreviewLibPlatform initialPlatform = PreviewLibPlatform.instance;

  test('$MethodChannelPreviewLib is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPreviewLib>());
  });

  test('getPlatformVersion', () async {
    PreviewLib previewLibPlugin = PreviewLib();
    MockPreviewLibPlatform fakePlatform = MockPreviewLibPlatform();
    PreviewLibPlatform.instance = fakePlatform;
  
    expect(await previewLibPlugin.getPlatformVersion(), '42');
  });
}
