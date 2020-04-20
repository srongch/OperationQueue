//
//  GalleryTests.swift
//  GalleryTests
//
//  Created by Dumbo on 13/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import XCTest
@testable import Gallery

class GalleryTests: XCTestCase {

    var viewModel: GalleryViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = GalleryViewModel.init(fileNamanagable: DocumentFileManager(), queue: OperationQueue())
        
    }

    func testLoadFile() {
        let exp = expectation(description: "LoadFile finish")
        exp.expectedFulfillmentCount = 2
        
        self.viewModel.onImageProcessed = { indexPath in
            XCTAssertNotNil(self.viewModel.loadImage(at: IndexPath.init(row: 0, section: 0), size: CGSize.init(width: 100, height: 100), notifiedWhenFinish: true))
            XCTAssertEqual(0, indexPath.row)
            exp.fulfill()
        }
        self.viewModel.loadFiles { error in
            XCTAssertNil(error)
            
            XCTAssertTrue(self.viewModel.numberOfItem() > 0)
            XCTAssertNotNil(self.viewModel.itemAtIdex(index: 0))
            
            XCTAssertNil(self.viewModel.loadImage(at: IndexPath.init(row: 0, section: 0), size: CGSize.init(width: 100, height: 100), notifiedWhenFinish: true))
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
