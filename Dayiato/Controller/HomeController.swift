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

class HomeController: UIViewController, ReloadDataDelegate {
   
    // MARK: - Properties
    var delegate: HomeControllerDelegate?
    var tableView: UITableView!
    
    var dayiatos:Results<Dayiato>?
    var categories:Results<Category>?
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    var dayiatoImageView: UIImageView = {
        let dayiatoImageView = UIImageView()
        dayiatoImageView.image = UIImage(named: "backgroundView")
        dayiatoImageView.clipsToBounds = true
        dayiatoImageView.contentMode = .scaleAspectFill
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
        navigationItem.title = "Dayiato"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButton))
        
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
    }
    
    func reloadData() {
        loadData()
        tableView.reloadData()
        refreshDayiatoView()
    }
    
    
    func configureUI() {
        
        // TABLE VIEW
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.register(DayiatoCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = .lightGray
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 80.0
        
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.sectionHeaderHeight = view.safeAreaLayoutGuide.layoutFrame.size.height / 2.5
        tableView.tableFooterView = UIView()
        tableView.headerView(forSection: 0)
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
}

// MARK: - UITableViewDelegate/DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayiatos?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        } 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dayiatos = dayiatos?[indexPath.row] {
            MainDayiato.sharedInstance.dayiato = dayiatos
            refreshDayiatoView()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

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
    }
}
