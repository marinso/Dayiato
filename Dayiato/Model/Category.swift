//
//  Category.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 27/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var iconName: String = ""
    let dayiatos = List<Dayiato>()
}
