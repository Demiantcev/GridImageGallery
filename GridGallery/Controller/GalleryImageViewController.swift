//
//  GalleryImageViewController.swift
//  GridGallery
//
//  Created by Кирилл Демьянцев on 29.04.2023.
//

import UIKit

class GalleryImageViewController: UIViewController {
    
    private let url = URL(string: "https://it-link.ru/test/images.txt")
    static var urlSelectedPhoto: String?
    var arrayFromText: [String] = []
    let itemPerRow: CGFloat = 3
    let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor(named: "backgroundColor")
        collection.dataSource = self
        collection.delegate = self
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var themeSegmented: UISegmentedControl = {
        var segmented = UISegmentedControl(items: ["device", "light", "dark"])
        segmented.backgroundColor = #colorLiteral(red: 0.2077701986, green: 0.2103852332, blue: 0.2103391886, alpha: 1)
        segmented.selectedSegmentIndex = 0
        segmented.tintColor = UIColor(named: "otherColor")
        segmented.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmented
    }()
    
    @objc private func segmentChanged() {
        MTUserDefaults.shared.theme = Theme(rawValue: themeSegmented.selectedSegmentIndex) ?? .device
        view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        loadFile()
        setupViews()
        navigationItem.titleView = themeSegmented
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func loadFile() {
        
        FileDownloader.loadFileAsync(url: url!) { (path, error)
            in print("PDF File downloaded to : \(path!)")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        do {
            if let fileUrls = try? FileManager.default.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil) {
                if let textContent = try? String(contentsOf: fileUrls[0], encoding:.utf8) {
                    arrayFromText = textContent.components(separatedBy:"\r\n")
                    arrayFromText.remove(at: 8)
                    arrayFromText.remove(at: 0)
                }
            }
        }
    }
    
    private func setupViews() {
        
        themeSegmented.selectedSegmentIndex = MTUserDefaults.shared.theme.rawValue
    }
    
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}
extension GalleryImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayFromText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        
        guard let url = URL(string: arrayFromText[indexPath.row]) else { return UICollectionViewCell() }
        cell.imageCell.getImage(withURL: url) { img in
            cell.imageCell.image = img
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newViewController = DetailViewController()
        navigationController?.pushViewController(newViewController, animated: true)
        GalleryImageViewController.urlSelectedPhoto = arrayFromText[indexPath.row]
    }
}
extension GalleryImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
