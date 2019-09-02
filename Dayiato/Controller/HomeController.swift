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
    var dayiatoView: UIView!
    
    var dayiatos:Results<Dayiato>?
    var categories:Results<Category>?
    
    var realm = try! Realm()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Dayiato"
        // withRenderingMode zapewniam nam, że kolor zawsze będzie biały
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButton))
        
        addButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = addButton
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    
    func configureUI() {
        
        // TABLE VIEW
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        tableView.register(DayiatoCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.backgroundColor = .gray
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 80.0
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 2 ).isActive = true
        
        tableView.tableFooterView = UIView()
        
        // DAYIATO VIEW
        dayiatoView = UIView()
        dayiatoView.backgroundColor = .gray
        
        view.addSubview(dayiatoView)

        dayiatoView.translatesAutoresizingMaskIntoConstraints = false
        dayiatoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dayiatoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dayiatoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dayiatoView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
    }
    
    // MARK: - REALM
    
    func loadData() {
        categories = realm.objects(Category.self)
        dayiatos = realm.objects(Dayiato.self)
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayiatos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! DayiatoCell
        
        cell.descriptionLabel.text = dayiatos?[indexPath.row].title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let dateString = dateFormatter.string(from: (dayiatos?[indexPath.row].date)!)
        
        cell.dateLabel.text = dateString
        
        if let days = dayiatos?[indexPath.row].counting() {
            cell.amountOfDays.text = "\(days)"
        }
        
       
        return cell
    }
}

