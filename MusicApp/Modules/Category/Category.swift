//
//  Category.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Category {
    
    let name: String
    let newlink: String
    let hotlink: String
    
    init(name: String, newlink: String, hotlink: String) {
        self.name = name
        self.newlink = newlink
        self.hotlink = hotlink
    }
    
    init(json: [String:Any]) {
        guard let name = json["name"] as? String        else { fatalError("Can not get category name") }
        guard let newlink = json["newlink"] as? String  else { fatalError("Can not get category newlink") }
        guard let hotlink = json["hotlink"] as? String  else { fatalError("Can not get category hotlink") }
        
        self.init(name: name, newlink: newlink, hotlink: hotlink)
    }
    
}
