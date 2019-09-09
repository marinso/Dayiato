//
//  AddDayiatoCell.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 28/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class AddDayiatoCell: UITableViewCell {
    
    var cellType: OptionInCell? {
        didSet {
            guard let cellType = cellType else { return }
            textLabel?.text = cellType.description
            textField.isHidden = !cellType.containsTitleLabel
            categoryLabel.isHidden = !cellType.containsCategoryName
            switchCover.isHidden = !cellType.containsSwitch
        }
    }
    
    let textField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Title"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(AddDayiatoController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    let categoryLabel: UILabel = {
        var label = UILabel()
        label.text = "Select Category"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    
    let switchCover: UISwitch = {
        var switchCover = UISwitch()
        switchCover.addTarget(self, action: #selector(AddDayiatoController.switchDidChange(_:)), for: UIControl.Event.valueChanged)
        return switchCover
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 80).isActive = true
        
        addSubview(switchCover)
        switchCover.translatesAutoresizingMaskIntoConstraints = false
        switchCover.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchCover.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
