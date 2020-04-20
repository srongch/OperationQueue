//
//  FileItem.swift
//  Gallery
//
//  Created by Dumbo on 20/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation

struct FileItem {
    let path: URL
    let fileExtension: String
    let fileName: String
    init?(url: URL?){
        guard let url = url else { return nil}
        self.path = url
        self.fileExtension = url.pathExtension
        self.fileName = url.deletingPathExtension().lastPathComponent
    }
}
