//
//  photoViewController.swift
//  OneDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

typealias voidBlk = () -> ()

class photoViewController:UIViewController {
    //MARK: properties
    lazy var imageView:UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var resultLabel:UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.alpha = 0
        return label
    }()
    
    var photoIndex:Int = -1
    
    var nextPhotoBlk:voidBlk?
    //MARK: init
    init(image:UIImage, photoIndex:Int) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        self.photoIndex = photoIndex
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.resultLabel)
        self._setupUI()
    }
    
    
    func _setupUI() {
        self.imageView.autoresizesSubviews = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.resultLabel.autoresizesSubviews = false
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.resultLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        self.resultLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.resultLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(_handleTapGes))
        self.view.addGestureRecognizer(tapGes)
        
    }
    
    //MARK: private methods
    @objc func _handleTapGes(sender:UIGestureRecognizer) {
        if(self.nextPhotoBlk != nil) {
            self.nextPhotoBlk!()
        }
    }
    
    //MARK: public methods
    func changeImage(image: UIImage, photoIndex: Int) {
//        self.imageView.alpha = 0
        self.imageView.image = image
        self.photoIndex = photoIndex
//        UIView.animate(withDuration: 1.5,
//                       delay: 0,
//                       usingSpringWithDamping: 0.6,
//                       initialSpringVelocity: 0.6,
//                       options: .beginFromCurrentState,
//                       animations: {
//            self.imageView.alpha = 1
//        },
//                       completion: nil)
    }
    
    func showAlert(msg:String) {
        let alertController = UIAlertController.init(title: "", message: msg, preferredStyle: .alert)
        let confirmAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
