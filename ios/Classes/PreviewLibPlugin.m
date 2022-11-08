#import "PreviewLibPlugin.h"
#if __has_include(<preview_lib/preview_lib-Swift.h>)
#import <preview_lib/preview_lib-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "preview_lib-Swift.h"
#endif

@implementation PreviewLibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPreviewLibPlugin registerWithRegistrar:registrar];
}
@end
