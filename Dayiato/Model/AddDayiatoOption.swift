//
//  AddDayiatoOption.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 29/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

protocol OptionInCell: CustomStringConvertible {
    var containsTitleLabel: Bool { get }
    var containsDatePicker: Bool { get }
    var containsCategoryName: Bool { get }
    var containsSwitch: Bool { get }
}

enum AddDayiatoOption: Int, CaseIterable, OptionInCell {
    
    case Title
    case Date
    case Category
    case setAsCover
    
    var description: String {
        switch self {
        case .Title: return "Title"
        case .Date: return "Date"
        case .Category: return "Category"
        case .setAsCover: return "Set as Cover"
        }
    }
    
    var containsTitleLabel: Bool {
        switch self {
        case .Title: return true
        case .Date: return false
        case .Category: return false
        case .setAsCover: return false
        }
    }
    
    var containsDatePicker: Bool {
        switch self {
        case .Title: return false
        case .Date: return true
        case .Category: return false
        case .setAsCover: return false
        }
    }
    
    var containsCategoryName: Bool {
        switch self {
        case .Title: return false
        case .Date: return false
        case .Category: return true
        case .setAsCover: return false
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .Title: return false
        case .Date: return false
        case .Category: return false
        case .setAsCover: return true
        }
    }
}
