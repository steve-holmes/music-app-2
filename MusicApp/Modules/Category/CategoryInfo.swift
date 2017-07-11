//
//  CategoryInfo.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/17/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct CategoryInfo {
    
    let category: Category
    let new: Bool
    
    init(category: Category, new: Bool) {
        self.category = category
        self.new = new
    }
    
    init(name: String, new: Bool, newlink: String, hotlink: String) {
        self.category = Category(name: name, newlink: newlink, hotlink: hotlink)
        self.new = new
    }
    
    init(json: [String:Any]) {
        guard let name = json["name"] as? String        else { fatalError("Can not get category name") }
        guard let subkind = json["suffix"] as? String   else { fatalError("Can not get category kind") }
        guard let newlink = json["newlink"] as? String  else { fatalError("Can not get category newlink") }
        guard let hotlink = json["hotlink"] as? String  else { fatalError("Can not get category hotlink") }
        
        let new = subkind == "new"
        
        self.init(name: name, new: new, newlink: newlink, hotlink: hotlink)
    }
    
    var name: String { return category.name }
    var newlink: String { return category.newlink }
    var hotlink: String { return category.hotlink }
    var link: String { return new ? category.newlink : category.hotlink }
    
}
