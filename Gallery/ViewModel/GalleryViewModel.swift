//
//  GalleryViewModel.swift
//  Gallery
//
//  Created by Dumbo on 14/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import UIKit

enum LoadingState {
    case finished (UIImage?)
    case loading
    var value: UIImage?{
                switch self {
        case .finished (let image):
            return image
        default:
            return nil
        }
    }
}

class GalleryViewModel {
    private let fileNamanagable: FileNamanagable
    private var fileList:[FileItem]?
    private let queue: OperationQueue
    private var imageCache: [String: LoadingState] = [:]
    var onImageProcessed: ((IndexPath) -> Void)?

    init(fileNamanagable: FileNamanagable, queue: OperationQueue ) {
        self.fileNamanagable = fileNamanagable
        self.queue = queue

    }
    
    func loadFiles(completion: @escaping (Error?)-> Void){
        do {
            self.fileList = try fileNamanagable.allFiles(filter: FileFilter.init(condition: .image))
            completion(nil)
        }catch let error{
            print(error)
            completion(error)
        }
    }
    
    func numberOfItem()-> Int {
        return self.fileList?.count ?? 0
    }
    
    func itemAtIdex(index: Int)-> FileItem? {
        return fileList?[index]
    }
    
    //return nil while image is still loading
    func imageNameAtIndex(indexPath: IndexPath) -> String?{
        return self.itemAtIdex(index: indexPath.row)?.fileName
    }
    
    func loadImage(at indexPath: IndexPath, size: CGSize, notifiedWhenFinish: Bool) -> UIImage?{

        guard let item = self.itemAtIdex(index: indexPath.row) else {return nil}
        
        if let cached = self.imageCache[item.fileName] {
            return (cached.value)
        }
        
        let op = LoadImageOperation(imageUrl: item.path)
        let resize = DownsamplingOperation(targetSize: CGSize(width: size.width, height: size.height))
        resize.addDependency(op)
        resize.onImageProcessed = { [weak self] image in
            print("finish \(item.fileName)")
            self?.imageCache[item.fileName] = LoadingState.finished(image)
            if notifiedWhenFinish {
                DispatchQueue.main.async {
                              self?.onImageProcessed?(indexPath)
                          }
                
            }
        }
        
        queue.addOperation(op)
        queue.addOperation(resize)
        self.imageCache[item.fileName] = LoadingState.loading
        return nil
        
    }
    
    
    
}
