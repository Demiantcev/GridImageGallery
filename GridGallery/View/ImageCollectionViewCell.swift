//
//  ImageCollectionViewCell.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 29.04.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "ImageCollectionViewCell"
    
    let cellView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageCell: MyImageView = {
        var image = MyImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        addSubview(cellView)
        cellView.addSubview(imageCell)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageCell.topAnchor.constraint(equalTo: cellView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ])
    }
}
