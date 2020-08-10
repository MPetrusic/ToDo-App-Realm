//
//  Button.swift
//  Todoey
//
//  Created by Milos Petrusic on 31/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class CustomButton: UIButton {

    required init(width:CGFloat, height:CGFloat, centerButton:Bool) {
        super.init(frame: .zero)

        // set other operations after super.init, if required
        self.setBackgroundImage(UIImage(named: "plus-button"), for: .normal)
        self.tintColor = UIColor(hexString: "eb3434")
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        if centerButton {
            self.centerXAnchor.constraint(equalTo: superview?.centerXAnchor ?? centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: superview?.centerYAnchor ?? centerYAnchor).isActive = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 1.0
        pulse.toValue = 0.0
        
        layer.add(pulse, forKey: nil)
    }

}
