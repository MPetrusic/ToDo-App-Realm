//
//  SettingViewController.swift
//  Todoey
//
//  Created by Milos Petrusic on 07/08/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    func configureUI() {
        navigationItem.title = "Settings"
        view.backgroundColor = UIColor(hexString: "404040")
    }
}

