//
//  Playlist.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Playlist {
    let id: String
    let name: String
    let singer: String
    let avatar: String
    
    init(id: String, name: String, singer: String, avatar: String) {
        self.id = id
        self.name = name
        self.singer = singer
        self.avatar = avatar
    }
    
    init(json: [String:Any]) {
        guard let id = json["id"] as? String           else { fatalError("Can not get playlist id") }
        guard let name = json["name"] as? String       else { fatalError("Can not get playlist name") }
        guard let singer = json["singer"] as? String   else { fatalError("Can not get playlist singer") }
        guard let avatar = json["avatar"] as? String   else { fatalError("Can not get playlist avatar") }
        
        self.init(id: id, name: name, singer: singer, avatar: avatar)
    }
}

extension Playlist: Equatable {}

func == (lhs: Playlist, rhs: Playlist) -> Bool {
    return lhs.id == rhs.id
}
