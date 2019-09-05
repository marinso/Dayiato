//
//  Dayiato.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 27/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import Foundation
import RealmSwift

class Dayiato: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType: Category.self , property: "dayiatos")

    func counting() -> Int {
        let calendar = Calendar.current
        var components: DateComponents

        // Replace the hour (time) of both dates with 00:00
        if let date = date {
            let dayiatoDay = calendar.startOfDay(for: date)
            let today = calendar.startOfDay(for: Date())
            
            if ( date > Date()) {
                components = calendar.dateComponents([.day], from: today, to: dayiatoDay)
                return components.day!
            } else {
                components = calendar.dateComponents([.day], from: dayiatoDay, to: today)
                return components.day!
            }
        }
        return -1
    }
}
