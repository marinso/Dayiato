//
//  protocols.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 16/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}

protocol AddDayiatoControllerDelegate {
    func passSelectedCategory(selectedCategory category: Category)
}

protocol ReloadDataDelegate {
    func reloadData()
}
