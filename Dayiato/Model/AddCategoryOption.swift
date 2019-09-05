//
//  AddCategoryOption.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 04/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

protocol OptionInAddCategoryCell: CustomStringConvertible {
    var containsCategoryNameTextField: Bool { get }
}

enum AddCategoryOption: Int, CaseIterable, OptionInAddCategoryCell {
    
    case Name
    case Icon
    
    var description: String {
        switch self {
        case .Name: return "Name"
        case .Icon: return "Icon"
        }
    }
    
    var containsCategoryNameTextField: Bool {
        switch self {
        case .Name: return true
        case .Icon: return false
        }
    }
}
