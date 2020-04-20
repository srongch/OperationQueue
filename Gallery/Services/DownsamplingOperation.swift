//
//  Downsampling.swift
//  Gallery
//
//  Created by Dumbo on 16/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class DownsamplingOperation: Operation {
    var outputImage: UIImage?
    
    private let inputImage: Data?
    private let targetSize: CGSize
     var onImageProcessed: ((UIImage?) -> Void)?
    
    init(image: Data? = nil, targetSize: CGSize) {
        inputImage = image
        self.targetSize = targetSize
        super.init()
    }
    
    override func main() {
        let dependencyImage = dependencies
            .compactMap { ($0 as? ImageDataProvider)?.data }
            .first
        
        guard let inputImage = inputImage ?? dependencyImage else {
            return
        }
        
        let resizing = Downsampling(inputImageData: inputImage, for: targetSize)
        guard
            let output = resizing.outputImage  else {
                 print("Failed to generate tilt shift image")
            return
        }
        let jpegData = output.jpegData(compressionQuality: 1.0)
        let jpegSize: Int = jpegData?.count ?? 0
        print("size of jpeg image in KB: %f ", Double(jpegSize) / 1024.0)
        outputImage = output
        
        if let onImageProcessed = onImageProcessed {
            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)
            }
        }
    }
}

