import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preview_lib/preview_lib_method_channel.dart';

void main() {
  MethodChannelPreviewLib platform = MethodChannelPreviewLib();
  const MethodChannel channel = MethodChannel('preview_lib');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
