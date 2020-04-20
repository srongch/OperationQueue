//
//  FileManager.swift
//  Gallery
//
//  Created by Dumbo on 14/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import MobileCoreServices

enum FileError: Error{
    case failed
}

enum FileType {
    
    case image
    var value: CFString {
        switch self {
        case .image:
            return kUTTypeImage
        }
    }
}

struct FileFilter {
    let condition: FileType
    func filter(ext : String)-> Bool{
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext as CFString, nil)
        return UTTypeConformsTo((uti?.takeRetainedValue())!, self.condition.value)
    }
}


protocol FileNamanagable {
    func allFiles(filter: FileFilter) throws -> [FileItem]
}

struct BundlFileManager: FileNamanagable {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    func allFiles(filter: FileFilter) throws -> [FileItem]{
        let items = try fm.contentsOfDirectory(atPath: path)
        let file = items.compactMap({FileItem.init(url: Bundle.main.url(forResource: $0, withExtension: ""))}).filter{
            filter.filter(ext: $0.fileExtension) }
        return file
  }
}

struct DocumentFileManager: FileNamanagable {
    let fm = FileManager.default
    var documentsUrl: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func allFiles(filter: FileFilter) throws -> [FileItem]{
        guard let documentUrl = documentsUrl else { throw FileError.failed }
        let items = try FileManager.default.contentsOfDirectory(at: documentUrl, includingPropertiesForKeys: nil)
        let file = items.compactMap({FileItem.init(url: $0)}).filter{
                   let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, $0.fileExtension as CFString, nil)
                   return UTTypeConformsTo((uti?.takeRetainedValue())!, kUTTypeImage) }
        return file
    }
}

