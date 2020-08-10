//
//  UpcomingViewController.swift
//  Todoey
//
//  Created by Milos Petrusic on 07/08/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import FSCalendar
import UIKit

class UpcomingViewController: UIViewController, FSCalendarDelegate {
    
    var calendar = FSCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        view.backgroundColor = UIColor(hexString: "404040")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300)
        view.addSubview(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print("\(string)")
    }
}
