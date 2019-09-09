//
//  SelectCategoryController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 01/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "CategoryCell"

class SelectCategoryController: UIViewController, ReloadDataDelegate {
    
    var tableView: UITableView!
    let realm = try! Realm()
    var categories: Results<Category>?
    var selectedCategory: Category?
    var delegate: AddDayiatoControllerDelegate!
    
    var addCategoryController = AddCategoryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        importCategory()
        configureUI()
        addCategoryController.delegate = self
    }
    
    func importCategory() {
        categories = realm.objects(Category.self)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureUI() {
        view.backgroundColor = .lightGray
        
        // Navigation
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Categories"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // TableView
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
    }
    
    func categoryWasSelected() {
        delegate?.passSelectedCategory(selectedCategory: selectedCategory!)
        navigationController?.popViewController(animated: true)
    }
    
    func handleNewCategoryButton() {
        navigationController?.pushViewController(addCategoryController, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension SelectCategoryController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categories!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
            cell.iconImageView.image = UIImage(named: categories?[indexPath.row].iconName ?? "calendar")
            cell.categoryNameLabel.text = categories?[indexPath.row].name
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "New Category"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if indexPath.section == 0 {
            cell?.accessoryType = .checkmark
            if let categories = categories {
                selectedCategory = categories[indexPath.row]
            }
            categoryWasSelected()
        } else {
           tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.section == 1, indexPath.row == 0 {
            handleNewCategoryButton()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            if let categoryForDeletion = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(categoryForDeletion.dayiatos)
                        realm.delete(categoryForDeletion)
                        reloadData()
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
                tableView.reloadData()
            }
        default:
            return
        }
    }
}
