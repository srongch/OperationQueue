//
//  ImageCell.swift
//  Gallery
//
//  Created by Dumbo on 14/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let reuseIdentifer = "gallery-cell-reuse-identifier"
    var featuredPhotoView = UIImageView()
    var spinner = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCell{
    func configure() {
        
        contentView.addSubview(featuredPhotoView)
        featuredPhotoView.contentMode = .scaleAspectFill
        
        featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
        featuredPhotoView.backgroundColor = .gray
        
        featuredPhotoView.layer.cornerRadius = 10
        featuredPhotoView.clipsToBounds = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .systemOrange
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        contentView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        NSLayoutConstraint.activate([
            featuredPhotoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            featuredPhotoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            featuredPhotoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            featuredPhotoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func loadImage(image: UIImage?){
        image != nil ? spinner.stopAnimating() : spinner.startAnimating()
     //   print("set image : \(image)")
        self.featuredPhotoView.image = image
    }
}
