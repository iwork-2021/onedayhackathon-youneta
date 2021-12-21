//
//  categoryTableViewCell.swift
//  OneDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

typealias didTapTableViewCellBlk = (categoryTableViewCell) -> ()

class categoryTableViewCell: UITableViewCell {
    
    //MARK: properties
    lazy var infoLabel:UILabel = {
        var label = UILabel()
        return label
    }()
    
    var didTapCellBlk: didTapTableViewCellBlk?
    
    //MARK: init
    init(infoString: String, style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.infoLabel.text = infoString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .lightGray
        self.addSubview(self.infoLabel)
        self._setupUI()
    }
    
    //MARK: setupUI
    func _setupUI() {
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(_handleTapCell))
        self.addGestureRecognizer(tapGes)
        
        self.infoLabel.autoresizesSubviews = false
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        self.infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.infoLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    
    @objc func _handleTapCell(sender: UITapGestureRecognizer) {
        if(self.didTapCellBlk != nil) {
            self.didTapCellBlk!(self)
        }
    }
}
