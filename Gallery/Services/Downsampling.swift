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

struct Downsampling {
    let inputImageData: Data
    let targetSize: CGSize
    var outputImage: UIImage?
    
    init(inputImageData:Data, for size: CGSize ) {
        self.inputImageData = inputImageData
        self.targetSize = size
        outputImage = self.resizedImage(self.inputImageData, for: self.targetSize)
    }
    
    func resizedImage(_ data: Data, for size: CGSize) -> UIImage? {
        guard let image = UIImage(data: data) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
