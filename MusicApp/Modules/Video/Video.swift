//
//  Video.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Video {
    let id: String
    let name: String
    let singer: String
    let avatar: String
    let time: String
    
    init(id: String, name: String, singer: String, avatar: String, time: String) {
        self.id = id
        self.name = name
        self.singer = singer
        self.avatar = avatar
        self.time = time
    }
    
    init(json: [String:Any]) {
        guard let id = json["id"] as? String            else { fatalError("Can not get video id") }
        guard let name = json["name"] as? String        else { fatalError("Can not get video name") }
        guard let singer = json["singer"] as? String    else { fatalError("Can not get video singer") }
        guard let avatar = json["avatar"] as? String    else { fatalError("Can not get video avatar") }
        guard let time = json["time"] as? String        else { fatalError("Can not get video time") }
        
        self.init(id: id, name: name, singer: singer, avatar: avatar, time: time)
    }
}

extension Video: Equatable {}

func == (lhs: Video, rhs: Video) -> Bool {
    return lhs.id == rhs.id
}
