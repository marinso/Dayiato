//
//  AddDayiatoController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 28/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import DatePickerCell
import RealmSwift

private let reuseIdentifier = "AddDayiatoCell"

class AddDayiatoController: UIViewController, AddDayiatoControllerDelegate {
    
    let realm = try! Realm()
    
    var tableView: UITableView!
    let datePickerCell = DatePickerCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
    var selectCategoryController = SelectCategoryController()
    var dayiatos: Results<Dayiato>?
    var flagForMainDayiato = false
    
    var dayiatoTitle: String?
    var dayiatoDate: Date = Date.init()
    var dayiatoCategory: Category?
    
    var delegate: ReloadDataDelegate!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
        selectCategoryController.delegate = self
    }
    
    @objc func handleDismiss() {
        delegate.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDoneButton() {
        
        if dayiatoTitle == "" || dayiatoTitle == nil {
            let alertController = UIAlertController(title: "", message: "Please input the title", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if dayiatoCategory == nil {
            let alertController = UIAlertController(title: "", message: "Please select the category", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let newDayiato = Dayiato()
        newDayiato.title = dayiatoTitle!
        newDayiato.date = dayiatoDate
        dayiatoCategory = dayiatoCategory!
            do {
                try realm.write {
                    dayiatoCategory!.dayiatos.append(newDayiato)
                    realm.add(newDayiato)
                    realm.add(dayiatoCategory!)
                    if flagForMainDayiato {
                        MainDayiato.sharedInstance.dayiato = newDayiato
                    }
                }
            } catch { print("Error saving context, \(error)") }
        handleDismiss()
    }
    
    func configureUI() {
        view.backgroundColor = .lightGray
        
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Add Dayiato"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        cancelButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleDoneButton))
        doneButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = doneButton
        
        // TableView
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(AddDayiatoCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        
        datePickerCell.datePicker.addTarget(self, action: #selector(pickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.dayiatoTitle = textField.text
    }
    
    @objc func switchDidChange(_ sender: UISwitch) {
        if sender.isOn {
            flagForMainDayiato = true
        } else {
            flagForMainDayiato = false
        }
    }
    
    @objc func pickerValueChanged() {
        dayiatoDate = datePickerCell.datePicker.date
    }
    
    func passSelectedCategory(selectedCategory category: Category) {
        dayiatoCategory = category
        tableView.reloadData()
    }
}

extension AddDayiatoController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Get the correct height if the cell is a DatePickerCell.
        
        if indexPath.row == 1 {
            return self.datePickerCell.datePickerHeight()
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            let cell = self.datePickerCell
            cell.selectedInTableView(tableView)
            self.tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(selectCategoryController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1 {
            let cell = self.datePickerCell
            cell.dateStyle = .medium
            cell.timeStyle = .none
            cell.datePicker.datePickerMode = .date
            cell.leftLabel.text = "Date"
            cell.rightLabelTextColor = .black
            cell.tintColor = .black
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddDayiatoCell
            let option = AddDayiatoOption(rawValue: indexPath.row)
            cell.selectionStyle = .none
            cell.cellType = option
            
            if option == .Category {
                if let dayiatoCategory = dayiatoCategory {
                    cell.categoryLabel.text = dayiatoCategory.name
                    cell.categoryLabel.textColor = .black
                }
            }
            return cell
        }
    }
}
