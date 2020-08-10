//
//  MenuOption.swift
//  Todoey
//
//  Created by Milos Petrusic on 10/08/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case today
    case upcoming
    case settings
    
    var description: String {
        switch self {
            
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .settings: return "Settings"
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .today: return UIImage(systemName: "pencil.circle") ?? UIImage()
        case .upcoming: return UIImage(systemName: "calendar.circle") ?? UIImage()
        case .settings: return UIImage(systemName: "gear") ?? UIImage()
        }
    }
    
}


