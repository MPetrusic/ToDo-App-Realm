//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Milos Petrusic on 03/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SideMenu

class CategoryTableViewController: SwipeTableViewController, MenuControllerDelegate {
    
    private var sideMenu: UISideMenuNavigationController?
    private var upcomingMenu = UpcomingViewController()
    private var settingsMenu = SettingsViewController()
    
    let realm = try! Realm()
    
    var categories: Results<Category>!
    
    let plusButton = CustomButton(width: 80, height: 80, centerButton: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuListController(with: [MenuOption.today, MenuOption.upcoming, MenuOption.settings])
        menu.delegate = self
        
        loadCategories()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hexString: "404040")
        setupBottomButton()
        addActionToBottomButton()
        sideMenu = UISideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.menuLeftNavigationController = sideMenu
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuWidth *= 1.5
        sideMenu?.setNavigationBarHidden(true, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        addChildControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist")}
        
        navBar.backgroundColor = UIColor(hexString: "fd5e53")
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(hexString: "fd5e53")
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            cell.layer.cornerRadius = 16
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = categoryColor
            backgroundView.layer.cornerRadius = 16
            cell.selectedBackgroundView = backgroundView
        }
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    //MARK: - Plus Button / Add New Categories
    
    func setupBottomButton() {
        tableView.addSubview(plusButton)
        if #available(iOS 11.0, *) {
             plusButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
             plusButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
             plusButton.rightAnchor.constraint(equalTo: tableView.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
             plusButton.bottomAnchor.constraint(equalTo: tableView.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    func addActionToBottomButton() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @IBAction func plusButtonTapped(_ sender: CustomButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Add new category"
            textField = addTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            // Called when user taps outside
        }))
        
        present(alert, animated: true, completion: nil)
        plusButton.pulsate()
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }

//MARK: - SideMenu Methods
    
    private func addChildControllers() {
        
        addChild(upcomingMenu)

        
        view.addSubview(upcomingMenu.view)

        
        upcomingMenu.view.frame = view.bounds

        
        upcomingMenu.didMove(toParent: self)

        
        upcomingMenu.view.isHidden = true
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: MenuOption) {
        sideMenu?.dismiss(animated: true, completion: nil)

//        title = named.description
        switch named {
        case .today:
            settingsMenu.view.isHidden = true
            upcomingMenu.view.isHidden = true
            title = "Today"
            
        case .upcoming:
            settingsMenu.view.isHidden = true
            upcomingMenu.view.isHidden = false
            

        case .settings:
            settingsMenu.view.isHidden = false
            upcomingMenu.view.isHidden = true
            
            if let settingsVC = storyboard?.instantiateViewController(identifier: "SettingsViewController") as? SettingsViewController {

                navigationController?.pushViewController(settingsVC, animated: true)
                
            }
        }
    }
//        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
//        menuViewController.didTapMenuType = { menuType in
//            print(menuType)
//            self.transitionToNew(menuType)
//        }
//        menuViewController.modalPresentationStyle = .overCurrentContext
//        menuViewController.transitioningDelegate = self
//        present(menuViewController, animated: true)
//
//        let tap = UITapGestureRecognizer(target: self, action:    #selector(self.handleTap(_:)))
//        transition.dimmingView.addGestureRecognizer(tap)
//    }
//
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func transitionToNew(_ menuType: MenuOption) {
//        let title = String(describing: menuType).capitalized
//        self.title = title
//
//        topView.removeFromSuperview()
//
//        switch menuType {
//        case .upcoming:
//            let view = UIView()
//            guard let upcomingVC = self.storyboard?.instantiateViewController(withIdentifier: "Upcoming") else { return }
//            view.addSubview(upcomingVC.view)
//            self.topView = upcomingVC.view
//            addChild(upcomingVC)
//            view.frame = self.view.bounds
//            self.view.addSubview(view)
//            self.topView = view
//            case .settings:
//            let view = UIView()
//           view.backgroundColor = .blue
//          view.frame = self.view.bounds
//           self.view.addSubview(view)
//            self.topView = view
//        default:
//            break
//        }
//    }

}


