//
//  SettingsController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 20/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    var named: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .red
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = named
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
}
