//
//  PreviewCameraError.swift
//  preview_lib
//
//  Created by Thao Vu Duc on 25/11/2022.
//

import Foundation

enum PreviewCameraError: Error {
    case noCamera
    case alreadyStarted
    case alreadyStopped
    case torchError(_ error: Error)
    case cameraError(_ error: Error)
    case torchWhenStopped
    case analyzerError(_ error: Error)
}
