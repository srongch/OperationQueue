//
//  ViewController.swift
//  Gallery
//
//  Created by Dumbo on 13/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cellHeightRatio: CGFloat = 0.6
    let cellInsect = NSDirectionalEdgeInsets.init(top: 5, leading: 15, bottom: 5, trailing: 15)

    var galleryCollectionView: UICollectionView! = nil
    var viewModel: GalleryViewModel!
    private let refreshControl = UIRefreshControl()
    
    lazy var cellSize: CGSize = {
        let scaleFactor = UIScreen.main.scale
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let screenSize = UIScreen.main.bounds.size
        let width = screenSize.width - (cellInsect.leading + cellInsect.trailing)
        let hieght = screenSize.width * cellHeightRatio
        return CGSize(width: width, height: hieght)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let queue = OperationQueue()
        queue.name = "gallery-image-download-queue"
        queue.qualityOfService = .default
        self.viewModel = GalleryViewModel.init(fileNamanagable: DocumentFileManager(), queue: queue)
        self.viewModel.onImageProcessed = { [weak self] indexPath in
                self?.galleryCollectionView.reloadItems(at: [indexPath])
            
        }
        
        configureCollectionView()
        self.title = "Gallery"
        self.refreshControl.beginRefreshing()
        self.loadFiles()
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifer)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        galleryCollectionView = collectionView
        view.addSubview(collectionView)
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl // iOS 10+
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        loadFiles()
    }
    
    private func loadFiles(){
        self.viewModel.loadFiles {[weak self] error in
         //   guard error != nil else {  return  }
            self?.galleryCollectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = cellInsect
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(CGFloat(cellHeightRatio)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 1)
        
        group.interItemSpacing = .fixed(CGFloat(10))
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.nu
        return self.viewModel.numberOfItem()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifer, for: indexPath) as! ImageCell
        
         let image = self.viewModel.loadImage(at: indexPath, size: cellSize, notifiedWhenFinish: true)
        cell.loadImage(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Begin asynchronously fetching data for the requested index paths.
        for indexPath in indexPaths {
            _ =   self.viewModel.loadImage(at: indexPath, size: cellSize, notifiedWhenFinish: true)
        }
    }
}
