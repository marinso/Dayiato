//
//  AddCategoryController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 02/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "reuseIdentifier"

class AddCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let realm = try! Realm()
    
    var categoryName:String?
    
    var delegate: ReloadDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .lightGray
        
        // Navigation
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Add Category"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancelButton))
        cancelButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(handleSaveButton))
        saveButton.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
        
        // TableView
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(AddCategoryCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    @objc func handleCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        let newCategory = Category()
        
        if let categoryName = categoryName {
            newCategory.name = categoryName
        }
        
        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        delegate.reloadData()
        handleCancelButton()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.categoryName = textField.text
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! AddCategoryCell
        let option = AddCategoryOption(rawValue: indexPath.row)
        cell.cellType = option
        cell.selectionStyle = .none
        return cell
    }
    
}
