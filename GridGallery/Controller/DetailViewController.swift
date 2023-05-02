//
//  DetailViewController.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 29.04.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let size: CGFloat = 200
    private var isExpanded = false
    
    lazy private var fullScreenPhoto: UIImageView = {
        let image = MyImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        if let selectedPhoto = GalleryImageViewController.urlSelectedPhoto {
            var url = URL(string: selectedPhoto)
            image.getImage(withURL: url!) { img in
                image.image = img
                self.activityIndicator.stopAnimating()
            }
        }
        return image
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "otherColor")
        activityIndicator.startAnimating()
        setupConstraints()
        addGesture()
        view.isUserInteractionEnabled = true
        navigationItem.title = "Full screen image"
    }
    
    private func addGesture() {
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        fullScreenPhoto.isUserInteractionEnabled = true
        fullScreenPhoto.addGestureRecognizer(pinchGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        }
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        
        self.isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            
            self.navigationController?.navigationBar.alpha = self.isExpanded ? 0 : 1
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(fullScreenPhoto)
        fullScreenPhoto.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            fullScreenPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullScreenPhoto.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fullScreenPhoto.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            fullScreenPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: fullScreenPhoto.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: fullScreenPhoto.centerYAnchor)
        ])
    }
}
