//
//  LoadImageOperation.swift
//  Gallery
//
//  Created by Dumbo on 15/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

final class LoadImageOperation: Operation {
  var outputImageData: Data?
  
  private let imageUrl: URL
  
  init(imageUrl: URL) {
    self.imageUrl = imageUrl
    super.init()
  }
  
  override func main() {
    
    guard let imageData:NSData = NSData(contentsOf: imageUrl) else{
      print("Failed to load image")
      return
    }
    outputImageData = imageData as Data
  }
}

extension LoadImageOperation: ImageDataProvider {
    var data: Data? {
         return self.outputImageData
    }
}
