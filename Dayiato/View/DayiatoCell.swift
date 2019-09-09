//
//  DayiatioCell.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 20/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class DayiatoCell: UITableViewCell {
    
    // MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "calendar")
//        iv.tintColor = .white
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = .black
        dl.font = UIFont.systemFont(ofSize: 18)
        dl.text = "Sample Text"
        return dl
    }()
    
    let dateLabel: UILabel = {
       let date = UILabel()
        date.textColor = .gray
        date.font = UIFont.systemFont(ofSize: 13)
        date.text = "2019-08-27"
        return date
    }()
    
    let amountOfDays: UILabel = {
        let days = UILabel()
        days.textColor = .black
        days.font = UIFont.systemFont(ofSize: 20)
        days.text = "233"
        return days
    }()
    
    let marker: UILabel = {
        let marker = UILabel()
        marker.textColor = .black
        marker.font = UIFont.systemFont(ofSize: 16)
        marker.text = "D"
        return marker
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        selectionStyle = .none
        addSubview(iconImageView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 18).isActive = true
        
        addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 12).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 18).isActive = true
        
        addSubview(amountOfDays)
        
        amountOfDays.translatesAutoresizingMaskIntoConstraints = false
        amountOfDays.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        amountOfDays.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        
        addSubview(marker)
        
        marker.translatesAutoresizingMaskIntoConstraints = false
        marker.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        marker.rightAnchor.constraint(equalTo: amountOfDays.rightAnchor, constant: 15 ).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
}
