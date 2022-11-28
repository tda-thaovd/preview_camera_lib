import Flutter
import UIKit
import AVFoundation

public class SwiftPreviewLibPlugin: NSObject, FlutterPlugin {
    private let previewCamera :PreviewCamera
    
    init(registry: FlutterTextureRegistry) {
            self.previewCamera = PreviewCamera(registry: registry)
            super.init()
        }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "com.demo.preview_camera/method", binaryMessenger: registrar.messenger())
    let instance = SwiftPreviewLibPlugin(registry: registrar.textures())
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "state":
          result(previewCamera.checkPermission())
      case "request":
          AVCaptureDevice.requestAccess(for: .video, completionHandler: { result($0) })
      case "start":
          start(call, result)
      default:
          result(FlutterMethodNotImplemented)
      }
  }
    
    private func start(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("start")
        let position = AVCaptureDevice.Position.back
        do {
            let parameters = try previewCamera.start(cameraPosition: position)
                        result(["textureId": parameters.textureId, "size": ["width": parameters.width, "height": parameters.height], "torchable": parameters.hasTorch])
        } catch PreviewCameraError.alreadyStarted {
            result(FlutterError(code: "MobileScanner",
                                message: "Called start() while already started!",
                                details: nil))
        } catch PreviewCameraError.noCamera {
            result(FlutterError(code: "MobileScanner",
                                message: "No camera found or failed to open camera!",
                                details: nil))
        } catch PreviewCameraError.torchError(let error) {
            result(FlutterError(code: "MobileScanner",
                                message: "Error occured when setting toch!",
                                details: error))
        } catch PreviewCameraError.cameraError(let error) {
            result(FlutterError(code: "MobileScanner",
                                message: "Error occured when setting up camera!",
                                details: error))
        } catch {
            result(FlutterError(code: "MobileScanner",
                                message: "Unknown error occured..",
                                details: nil))
        }
    }
}
