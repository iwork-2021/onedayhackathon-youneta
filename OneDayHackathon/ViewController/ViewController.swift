//
//  ViewController.swift
//  OneDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit
import CoreML
import CoreMedia
import Vision

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: properties
    lazy var albumCategoryArray:NSMutableArray = {
        //element: String
        var arr = NSMutableArray()
        return arr
    }()
    
    lazy var allPhotoArray:NSMutableArray = {
       var arr = NSMutableArray()
        return arr
    }()
    
    lazy var emptyLabel:UILabel = {
        var label = UILabel()
        label.text = "No photos yet. Press \"Add Photo\" to start."
        label.textAlignment = .center
        label.font = UIFont.init(name: "Georgia-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    lazy var albumCategoryDict:NSMutableDictionary = {
        //key: String
        //value: [UIImage]
        var dict = NSMutableDictionary()
        return dict
    }()
    
    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(categoryTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(categoryTableViewCell.self))
        return tableView
    }()
        
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try snacks(configuration: MLModelConfiguration())
            
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
            
            
        } catch {
            fatalError("Failed to create request")
        }
    }()
    
    var tempImage:UIImage?
    var tempResult:String?
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Smart Album"
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.emptyLabel)
        self.view.backgroundColor = .white
        self._setupUI()
        // Do any additional setup after loading the view.
    }

    func _setupUI() {
        self._setupAddNewPhotoBtn()
        self._setupViewAllBtn()
        
        self.tableView.autoresizesSubviews = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.emptyLabel.autoresizesSubviews = false
        self.emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.emptyLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.emptyLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.emptyLabel.alpha = 1
    }
    
    //MARK: tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let string = self.albumCategoryArray[indexPath.row] as! String
        let infoString = string.appendingFormat("(%d)", (self.albumCategoryDict.object(forKey: string) as! NSMutableArray).count)
        let cell = categoryTableViewCell.init(infoString: infoString, style: .default, reuseIdentifier: string)
        weak var weakSelf = self
        cell.didTapCellBlk = { (cell:categoryTableViewCell) -> () in
            weakSelf!._handleTapCell(cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumCategoryArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: private methods
    func _setupAddNewPhotoBtn() {
        let addNewPhotoBtn = UIButton.init(type: .custom)
        addNewPhotoBtn.setTitle("Add Photo", for: .normal)
        addNewPhotoBtn.setTitleColor(.systemBlue, for: .normal)
        addNewPhotoBtn.addTarget(self, action: #selector(_handleAddNewPhoto), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addNewPhotoBtn)
    }
    
    func _setupViewAllBtn() {
        let addNewPhotoBtn = UIButton.init(type: .custom)
        addNewPhotoBtn.setTitle("View All", for: .normal)
        addNewPhotoBtn.setTitleColor(.systemBlue, for: .normal)
        addNewPhotoBtn.addTarget(self, action: #selector(_handleViewAll), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addNewPhotoBtn)
    }
    
    @objc func _handleAddNewPhoto(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController.init(title: "Add Photo", message: "", preferredStyle: .alert)
        let chooseFromLibraryAction = UIAlertAction.init(title: "Choose from library", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let takePhotoAction = UIAlertAction.init(title: "Take a photo", style: .default) { (action) in
            let cameraEnable:Bool = UIImagePickerController.isSourceTypeAvailable(.camera)
            if(cameraEnable) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
            else {
                let errorAlertController = UIAlertController.init(title: "Error", message: "Camera is not available.", preferredStyle: .alert)
                let confirmAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                errorAlertController.addAction(confirmAction)
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(chooseFromLibraryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func _handleViewAll(sender: UIBarButtonItem) {
        if(self.allPhotoArray.count == 0) {
            let errorAlertController = UIAlertController.init(title: "Error", message: "No photos yet.", preferredStyle: .alert)
            let confirmAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            errorAlertController.addAction(confirmAction)
            self.present(errorAlertController, animated: true, completion: nil)
        }
        else {
            let galleryVC = galleryViewController.init(imageArray: self.allPhotoArray, title: "All Photos")
            self.navigationController?.pushViewController(galleryVC, animated: true)
        }
    }
    
    func _handleTapCell(cell: categoryTableViewCell) {
//        let indexPath = self.tableView.indexPath(for: cell)
//        let key = self.albumCategoryArray[indexPath!.row] as! String
        let key = cell.reuseIdentifier
        let galleryVC = galleryViewController.init(imageArray: self.albumCategoryDict.object(forKey: key!) as! NSMutableArray, title:key!)
        self.navigationController?.pushViewController(galleryVC, animated: true)
    }
    
    func _classify(image: UIImage) {
      guard let imageCI = CIImage(image: image)
      else { return }
      let orientation = CGImagePropertyOrientation(image.imageOrientation)
      DispatchQueue.main.async {
        let handler = VNImageRequestHandler(ciImage: imageCI, orientation: orientation, options: [:] )
        do {
          try handler.perform([self.classificationRequest])
        } catch {
          print("Failed to perform classification: \(error)")
        }
      }
    }
    
}
//MARK: imagePicker delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as! UIImage
        self.tempImage = image
        self._classify(image: image)
    }
}

//MARK: process Observations
extension ViewController {
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNClassificationObservation] {
            if results.isEmpty {

            } else {
                let result = results[0].identifier
                let confidence = results[0].confidence
                self.tempResult = result
                
                let photoVC = photoViewController.init(image: self.tempImage!, photoIndex: -1)
                photoVC.resultLabel.alpha = 1
                if(confidence * 100 < 75) {
                    photoVC.resultLabel.text = "I'm not sure. Maybe it's not a food. :("
                    self.tempResult = "others"
                }
                else {
                    photoVC.resultLabel.text = result.appendingFormat(", confidence: %.2f%%", confidence*100)
                }
                
                
                let addConfirmBtn = UIButton.init(type: .custom)
                addConfirmBtn.setTitle("Add Photo", for: .normal)
                addConfirmBtn.setTitleColor(.systemBlue, for: .normal)
                addConfirmBtn.addTarget(self, action: #selector(_handleConfirmAddPhoto), for: .touchUpInside)
                photoVC.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: addConfirmBtn)
                self.navigationController?.pushViewController(photoVC, animated: true)
                print(result)
          }
        }
        else if let error = error {
            print(error)
        } else {

        }
    }
    @objc func _handleConfirmAddPhoto(sender: UIBarButtonItem) {
        self.allPhotoArray.add(self.tempImage!)
        if((self.albumCategoryDict.object(forKey: self.tempResult!)) != nil) {
            //exist
            let imageArray:NSMutableArray = self.albumCategoryDict.object(forKey: self.tempResult!) as! NSMutableArray
            imageArray.add(self.tempImage!)
            self.albumCategoryDict.setValue(imageArray, forKey: self.tempResult!)
        }
        else {
            self.albumCategoryArray.add(self.tempResult!)
            let imageArray:NSMutableArray = [self.tempImage!]
            self.albumCategoryDict.setValue(imageArray, forKey: self.tempResult!)
        }
        if(self.emptyLabel.alpha == 1) {
            self.emptyLabel.alpha = 0
        }
        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
}
