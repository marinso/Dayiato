//
//  MenuOption.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 20/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Categories
    case Dayiatos
    
    var description: String {
        switch self {
            case .Categories: return "Categories"
            case .Dayiatos: return "Dayiatos"
        }
    }
    
    var image: UIImage {
        switch self {
            case .Categories: return UIImage(named: "menu") ?? UIImage()
            case .Dayiatos: return UIImage(named: "menu") ?? UIImage()
        }
    }

    
    
}
