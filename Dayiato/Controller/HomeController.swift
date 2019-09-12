//
//  HomeController.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 16/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifer = "DayiatoCell"
private let categoryIdentifer = "CategoryCell"

class HomeController: UIViewController, ReloadDataDelegate {
   
    // MARK: - Properties
    var delegate: HomeControllerDelegate?
    var tableViewForDayiatos: UITableView!
    var tableViewForCategories: UITableView!
    var shouldExpandCategories = true
    var dayiatos:Results<Dayiato>?
    var categories:Results<Category>?
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var dayiatoImageView: UIImageView = {
        let dayiatoImageView = UIImageView()
        dayiatoImageView.image = UIImage(named: "backgroundView")
        dayiatoImageView.contentMode = .scaleAspectFill
        dayiatoImageView.clipsToBounds = true

        return dayiatoImageView
    }()
    
    var dayiatoTopLabel: UILabel = {
        let dayiatoTopLabel = UILabel()
        dayiatoTopLabel.font = UIFont.systemFont(ofSize: 19)
        dayiatoTopLabel.textColor = .white
        return dayiatoTopLabel
    }()
    
    var dayiatoNameLabel: UILabel = {
        let dayiatoNameLabel = UILabel()
        dayiatoNameLabel.font = UIFont.systemFont(ofSize: 28)
        dayiatoNameLabel.textColor = .white
        return dayiatoNameLabel
    }()
    
    var dayiatoDaysLabel: UILabel = {
        let dayiatoDaysLabel = UILabel()
        dayiatoDaysLabel.font = UIFont.systemFont(ofSize: 85)
        dayiatoDaysLabel.textColor = .white
        return dayiatoDaysLabel
    }()
    
    var dayiatoDateLabel: UILabel = {
        let dayiatoDateLabel = UILabel()
        dayiatoDateLabel.font = UIFont.systemFont(ofSize: 19)
        dayiatoDateLabel.textColor = .white
        return dayiatoDateLabel
    }()
    
    // Properties for tableViewForCategories
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let navigationBarTitleButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 35)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.titleLabel?.textAlignment = .center
//        button.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        button.setTitle("Dayiatos", for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
    
        configureNavigationBar()
        configureUI()
        loadData()
    }
    
    // MARK: - Handlers
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleAddButton() {
        let controller = AddDayiatoController()
        if let dayiatos = dayiatos {
            controller.dayiatos = dayiatos
        }
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationBarTitleButton.addTarget(self, action: #selector(animateCategoriesSelector), for: .touchUpInside)
        navigationItem.titleView = navigationBarTitleButton
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButton))
        
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
    }
    
    func reloadData() {
        loadData()
        tableViewForDayiatos.reloadData()
        tableViewForCategories.reloadData()
        refreshDayiatoView()
    }
    
    
    func configureUI() {
        
        // TABLE VIEW
        tableViewForDayiatos = UITableView()
        tableViewForDayiatos.delegate = self
        tableViewForDayiatos.dataSource = self
        
        view.addSubview(tableViewForDayiatos)
        
        tableViewForDayiatos.register(DayiatoCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableViewForDayiatos.backgroundColor = .lightGray
        tableViewForDayiatos.separatorStyle = .singleLine
        tableViewForDayiatos.rowHeight = 80.0
        
        view.addSubview(tableViewForDayiatos)

        tableViewForDayiatos.translatesAutoresizingMaskIntoConstraints = false
        tableViewForDayiatos.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableViewForDayiatos.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableViewForDayiatos.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewForDayiatos.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewForDayiatos.sectionHeaderHeight = view.safeAreaLayoutGuide.layoutFrame.size.height / 2.5
        tableViewForDayiatos.tableFooterView = UIView()
        tableViewForDayiatos.headerView(forSection: 0)
        
        // TABLE VIEW FOR CATEGORIES
        
        tableViewForCategories = UITableView(frame: CGRect(x: CGFloat(view.frame.size.width / 2 - 100 ), y: CGFloat(80), width: CGFloat(200), height: CGFloat(160)), style: .plain)
        tableViewForCategories.delegate = self
        tableViewForCategories.dataSource = self
        
        view.addSubview(tableViewForCategories)
        
        tableViewForCategories.register(CategoryCell.self, forCellReuseIdentifier: categoryIdentifer)
        tableViewForCategories.separatorStyle = .singleLine
        tableViewForCategories.rowHeight = 40.0
        tableViewForCategories.sectionHeaderHeight = 0
        tableViewForCategories.layer.cornerRadius = 10
        tableViewForCategories.isHidden = true
        let view = UIView()
        view.backgroundColor = UIColor(hue: 0.6667, saturation: 0.0205, brightness: 0.9569, alpha: 1)
        tableViewForCategories.tableFooterView = view
        tableViewForCategories.isEditing = false
    }
    
    // MARK: - REALM
    
    func loadData() {
        categories = realm.objects(Category.self)
        dayiatos = realm.objects(Dayiato.self)
    }
    
    func refreshDayiatoView() {
        if let dayiato = MainDayiato.sharedInstance.dayiato {
            dayiatoTopLabel.text = dayiato.future() ? "DAYS UNTIL" : "DAYS SINCE"
            dayiatoNameLabel.text = dayiato.title
            dayiatoDaysLabel.text = "\(dayiato.counting())"
            dayiatoDateLabel.text = dayiato.displayDate()
        }
    }
    
    @objc func animateCategoriesSelector() {
        self.tableViewForCategories.isHidden = false
        if shouldExpandCategories {
            UITableView.animate(withDuration: 0.4, animations: {
                    self.tableViewForCategories.alpha = 1
            })
        } else {
            UITableView.animate(withDuration: 0.4, animations: {
                self.tableViewForCategories.alpha = 0
            }, completion: {
                (value: Bool) in
                self.tableViewForCategories.isHidden = true
            })
            
        }
        shouldExpandCategories = !shouldExpandCategories
    }
}

// MARK: - UITableViewDelegate/DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewForDayiatos {
            return dayiatos?.count ?? 0
        } else {
            return (categories?.count ?? 1) + 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let returnCell = UITableViewCell()
        
        if tableView == self.tableViewForDayiatos {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! DayiatoCell
            
            if let dayiato = dayiatos?[indexPath.row] {
                cell.backgroundColor = UIColor(hue: 0.6667, saturation: 0.0205, brightness: 0.9569, alpha: 1)
                cell.descriptionLabel.text = dayiato.title
                cell.dateLabel.text = dayiato.displayDate()
                cell.amountOfDays.text = "\(dayiato.counting())"
                cell.iconImageView.image = UIImage(named: dayiato.parentCategory[0].iconName)
                
                if !dayiato.future() {
                    cell.amountOfDays.textColor = UIColor(red: 87/255, green: 135/255, blue: 212/255, alpha: 1)
                    cell.marker.textColor = UIColor(red: 87/255, green: 135/255, blue: 212/255, alpha: 1)
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryIdentifer, for: indexPath) as! CategoryCell
            
            if indexPath.row == 0 {
                cell.categoryNameLabel.text = "All categories"
                cell.categoryNameLabel.textAlignment = .center
            } else {
                if let cat = categories?[indexPath.row-1] {
                    cell.iconImageView.image = UIImage(named: cat.iconName)
                    cell.categoryNameLabel.text = cat.name
                }
            }
            return cell
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableViewForDayiatos {
            if let dayiatos = dayiatos?[indexPath.row] {
                MainDayiato.sharedInstance.dayiato = dayiatos
                refreshDayiatoView()
            }
        } else if tableView == self.tableViewForCategories {
            
            shouldExpandCategories = false
            loadData()
            if indexPath.row > 0 {
                dayiatos = dayiatos?.filter("ANY parentCategory.name CONTAINS[cd] %@", categories?[indexPath.row-1].name ?? "")
                navigationBarTitleButton.titleLabel?.text = categories?[indexPath.row-1].name
            } else {
                navigationBarTitleButton.titleLabel?.text = "Dayiatos"
            }
            tableViewForDayiatos.reloadData()
            animateCategoriesSelector()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.tableViewForDayiatos {
            switch editingStyle {
            case .delete:
                if let dayiatoForDeletion = dayiatos?[indexPath.row] {
                    do {
                        try realm.write {
                            realm.delete(dayiatoForDeletion)
                        }
                    } catch {
                        print("Error deleting dayiato, \(error)")
                    }
                    tableView.reloadData()
                }
            default: return
            }
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == self.tableViewForCategories {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == self.tableViewForDayiatos {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.size.height))
            
            headerView.addSubview(dayiatoImageView)
            dayiatoImageView.translatesAutoresizingMaskIntoConstraints = false
            dayiatoImageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            dayiatoImageView.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
            dayiatoImageView.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
            dayiatoImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            
            headerView.addSubview(dayiatoTopLabel)
            dayiatoTopLabel.translatesAutoresizingMaskIntoConstraints = false
            dayiatoTopLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -headerView.frame.size.height / 8).isActive = true
            dayiatoTopLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
            
            headerView.addSubview(dayiatoNameLabel)
            dayiatoNameLabel.translatesAutoresizingMaskIntoConstraints = false
            dayiatoNameLabel.centerYAnchor.constraint(equalTo: dayiatoTopLabel.centerYAnchor, constant: 50).isActive = true
            dayiatoNameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
            
            headerView.addSubview(dayiatoDaysLabel)
            dayiatoDaysLabel.translatesAutoresizingMaskIntoConstraints = false
            dayiatoDaysLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 30).isActive = true
            dayiatoDaysLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
            
            headerView.addSubview(dayiatoDateLabel)
            dayiatoDateLabel.translatesAutoresizingMaskIntoConstraints = false
            dayiatoDateLabel.centerYAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30).isActive = true
            dayiatoDateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
            
            return headerView
        } else { return UIView() }
    }
}
