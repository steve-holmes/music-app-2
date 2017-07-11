//
//  Singer.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Singer {
    
    let id: String
    let name: String
    let avatar: String
    
    init(id: String, name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
    init(json: [String:Any]) {
        guard let id = json["id"] as? String            else { fatalError() }
        guard let name = json["name"] as? String        else { fatalError() }
        guard let avatar = json["avatar"] as? String    else { fatalError() }
        
        self.init(id: id, name: name, avatar: avatar)
    }
    
}

extension Singer: Equatable {
    
    static func == (lhs: Singer, rhs: Singer) -> Bool {
        return lhs.id == rhs.id
    }
    
}
