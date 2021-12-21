//
//  galleryViewController.swift
//  OneDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit
class galleryViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    //properties
    lazy var imageArray:NSMutableArray = {
        //element: UIImage
        var arr = NSMutableArray()
        return arr
    }()
    
    lazy var galleryCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: (self.view.frame.width - 10) / 3, height: 200)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(galleryCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(galleryCollectionViewCell.self))
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: init
    init(imageArray: NSMutableArray, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageArray = imageArray
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.galleryCollectionView)
        self._setupUI()
    }
    
    func _setupUI() {
        self.galleryCollectionView.autoresizesSubviews = false
        self.galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.galleryCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.galleryCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.galleryCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.galleryCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    //MARK: UICollectionViewDelegate
    
    //MARK: UICollectionViewDatasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = self.imageArray[indexPath.row] as! UIImage
        let cell: galleryCollectionViewCell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(galleryCollectionViewCell.self), for: indexPath) as! galleryCollectionViewCell
        cell.imageView.image = image
        weak var weakSelf = self
        cell.didTapCellBlk = { (cell:galleryCollectionViewCell) -> () in
            weakSelf!._handleTapCell(cell: cell)
        }
        return cell
    }
    
    //MARK: private methods
    @objc func _handleTapCell(cell: galleryCollectionViewCell) {
        let indexPath = self.galleryCollectionView.indexPath(for: cell)
        let photoVC = photoViewController.init(image: self.imageArray[indexPath!.row] as! UIImage, photoIndex: indexPath!.row)
        photoVC.nextPhotoBlk = {() -> () in
            let nextIndex = photoVC.photoIndex + 1
            if(nextIndex >= self.imageArray.count) {
                photoVC.showAlert(msg: "This is the last photo in this category.")
            }
            else {
                photoVC.changeImage(image: self.imageArray[nextIndex] as! UIImage, photoIndex: nextIndex)
            }
        }
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
    
}
