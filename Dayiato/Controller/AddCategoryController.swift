//
//  AddCategoryController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 02/09/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

private let tableCell = "TableCell"
private let collectionCell = "CollectionCell"

class AddCategoryController: UIViewController {
    
    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    let realm = try! Realm()
    
    var categoryName:String?
    var categoryIcon:String = "calendar"
    var delegate: ReloadDataDelegate!
    
    // properties for collectionView
    let icons = ["calendar", "diamond", "doctor", "love", "study", "travel", "sad"]
    let numberOfItemsPerRow: CGFloat = 7.0
    var iconImage = UIImage(named: "calendar")
    let colorForCollectionView:UIColor = .white //UIColor(hue: 0.6667, saturation: 0.0205, brightness: 0.9569, alpha: 1)
    var heightCollectionView: CGFloat?
    
    var collectionExpanded: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(hue: 0.6667, saturation: 0.0205, brightness: 0.9569, alpha: 1)
        heightCollectionView = ((view.frame.width + 80) / 6) * 2
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
        tableView.register(AddCategoryCell.self, forCellReuseIdentifier: tableCell)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightCollectionView!).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.tableFooterView = UIView()
        
        // CollectionView
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(AddCategoryCollectionCell.self, forCellWithReuseIdentifier: collectionCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = colorForCollectionView
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightCollectionView!).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func handleCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        
        if categoryName == "" || categoryName == nil {
            let alertController = UIAlertController(title: "", message: "Please input the title", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let newCategory = Category()
        newCategory.name = categoryName!
        newCategory.iconName = categoryIcon
        
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
    
    func animateCollectionView() {
        if collectionExpanded {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                
                self.collectionView.frame.origin.y = self.view.frame.height - self.heightCollectionView!
                
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                
                self.collectionView.frame.origin.y = self.view.frame.height
                
            }, completion: nil)
        }
    }
}

// MARK: - TableView

extension AddCategoryController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as! AddCategoryCell
        let option = AddCategoryOption(rawValue: indexPath.row)
        cell.cellType = option
        cell.selectionStyle = .none
        
        if option! == .Icon {
            cell.iconImageView.image = iconImage
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            collectionExpanded = !collectionExpanded
            animateCollectionView()
        }
    }
}

// MARK: - CollectionView

extension AddCategoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! AddCategoryCollectionCell
        cell.backgroundColor = colorForCollectionView
        cell.imageView.image = UIImage(named: icons[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 50) / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .lightGray
        iconImage = UIImage(named: icons[indexPath.row])
        categoryIcon = icons[indexPath.row]
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = colorForCollectionView
    }

}
// MARK: - hideKeyboard extension

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
