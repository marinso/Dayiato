//
//  AddCategoryCell.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 04/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class AddCategoryCell: UITableViewCell {
    
    var cellType: OptionInAddCategoryCell? {
        didSet {
            guard let cellType = cellType else { return }
            textLabel?.text = cellType.description
            textField.isHidden = !cellType.containsCategoryNameTextField
            iconImageView.isHidden = !cellType.containsIconImageView
        }
    }
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "calendar")
        return iv
    }()
    
    let textField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Category Name"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(AddCategoryController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        
        addSubview(iconImageView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
