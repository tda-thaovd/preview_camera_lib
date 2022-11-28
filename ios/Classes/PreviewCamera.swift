//
//  PreviewCamera.swift
//  preview_lib
//
//  Created by Thao Vu Duc on 25/11/2022.
//

import Foundation
import AVFoundation

public class PreviewCamera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, FlutterTexture {

    
    /// Image to be sent to the texture
    var latestBuffer: CVImageBuffer!
    
    /// Capture session of the camera
    var captureSession: AVCaptureSession!

    /// The selected camera
    var device: AVCaptureDevice!
    
    /// Texture id of the camera preview for Flutter
    private var textureId: Int64!
    
    /// Default position of camera
    var videoPosition: AVCaptureDevice.Position = AVCaptureDevice.Position.back
    
    /// If provided, the Flutter registry will be used to send the output of the CaptureOutput to a Flutter texture.
    private let registry: FlutterTextureRegistry?
    
    init(registry: FlutterTextureRegistry?) {
        self.registry = registry
        super.init()
    }
    
    /// Check permissions for video
    func checkPermission() -> Int {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            return 0
        case .authorized:
            return 1
        default:
            return 2
        }
    }
    
    /// Request permissions for video
    func requestPermission(_ result: @escaping FlutterResult) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { result($0) })
    }

        /// Gets called when a new image is added to the buffer
        public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("Failed to get image buffer from sample buffer.")
                return
            }
            latestBuffer = imageBuffer
            registry?.textureFrameAvailable(textureId)
        }
    
    /// Start scanning for barcodes
    func start(cameraPosition: AVCaptureDevice.Position) throws -> MobileScannerStartParameters {
        if (device != nil) {
            throw PreviewCameraError.alreadyStarted
        }
        
        captureSession = AVCaptureSession()
        textureId = registry?.register(self)
        print("Thao: \(String(describing: textureId)) \(String(describing: registry)) ")
        // Open the camera device
        if #available(iOS 10.0, *) {
            device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: cameraPosition).devices.first
        } else {
            device = AVCaptureDevice.devices(for: .video).filter({$0.position == cameraPosition}).first
        }
        
        if (device == nil) {
            throw PreviewCameraError.noCamera
        }
        
        captureSession.beginConfiguration()
        // Add device input
        do {
            let input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
        } catch {
            throw PreviewCameraError.cameraError(error)
        }
        captureSession.sessionPreset = AVCaptureSession.Preset.photo;
        
        // Add video output.
        let videoOutput = AVCaptureVideoDataOutput()

        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoPosition = cameraPosition

        // calls captureOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession.addOutput(videoOutput)
        for connection in videoOutput.connections {
            connection.videoOrientation = .portrait
            if cameraPosition == .front && connection.isVideoMirroringSupported {
                connection.isVideoMirrored = true
            }
        }
        captureSession.commitConfiguration()
        captureSession.startRunning()
        let dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
        
        return MobileScannerStartParameters(width: Double(dimensions.height), height: Double(dimensions.width), hasTorch: device.hasTorch, textureId: textureId)
    }
    
    /// Sends output of OutputBuffer to a Flutter texture
    public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        if latestBuffer == nil {
            return nil
        }
        return Unmanaged<CVPixelBuffer>.passRetained(latestBuffer)
    }
    
    struct MobileScannerStartParameters {
        var width: Double = 0.0
        var height: Double = 0.0
        var hasTorch = false
        var textureId: Int64 = 0
    }
}
