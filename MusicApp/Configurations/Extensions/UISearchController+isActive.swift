//
//  UISearchController+isActive.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

extension UISearchController {
    
    func setInactive() {
        self.isActive = false
        self.resignFirstResponder()
    }
    
}
