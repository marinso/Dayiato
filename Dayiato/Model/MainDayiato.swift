//
//  File.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 06/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import RealmSwift

class MainDayiato {
    
    static let sharedInstance = MainDayiato()
    
    @objc dynamic var dayiato: Dayiato?
}
