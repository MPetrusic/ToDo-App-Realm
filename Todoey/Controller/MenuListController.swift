//
//  MenuListController.swift
//  Todoey
//
//  Created by Milos Petrusic on 07/08/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

private let reuseIndetifier = "MenuOptionCell"

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: MenuOption)
}

class MenuListController: UITableViewController {
    
    public var delegate: MenuControllerDelegate?
    
    var didTapMenuType: ((MenuOption) -> Void)?
    
    
    private let menuItems: [MenuOption]
    private let darkColor = UIColor(hexString: "404040")
    
    init(with menuItems: [MenuOption]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(MenuOptionCell.self,
                           forCellReuseIdentifier: reuseIndetifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = darkColor
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndetifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            // Relay to delegate about menu item selection
            let selectedItem = menuItems[indexPath.row]
            delegate?.didSelectMenuItem(named: selectedItem)
        }
}
