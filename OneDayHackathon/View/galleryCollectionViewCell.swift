//
//  galleryCollectionViewCell.swift
//  OneDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit
typealias didTapCollectionViewCellBlk = (galleryCollectionViewCell) -> ()

class galleryCollectionViewCell: UICollectionViewCell {
    
    //MARK: properties
    lazy var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var didTapCellBlk: didTapCollectionViewCellBlk?
    
    //MARK: life cycle
    override func layoutSubviews() {
        self.backgroundColor = .white
        super.layoutSubviews()
        self.addSubview(self.imageView)
        self._setupUI()
    }
    
    func _setupUI() {
        self.imageView.autoresizesSubviews = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(_handleDidTap))
        self.addGestureRecognizer(tapGes)
    }
    
    @objc func _handleDidTap(sender: UIGestureRecognizer) {
        if(self.didTapCellBlk != nil) {
            self.didTapCellBlk!(self)
        }
    }
}
