//
//  VideoTrack.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct VideoTrack {
    let id: String
    let name: String
    let singer: String
    let avatar: String
    let url: String
    
    init(id: String, name: String, singer: String, avatar: String, url: String) {
        self.id = id
        self.name = name
        self.singer = singer
        self.avatar = avatar
        self.url = url
    }
    
    init(json: [String:Any]) {
        guard let id = json["key"] as? String           else { fatalError("Can not get video track id") }
        guard let name = json["title"] as? String       else { fatalError("Can not get video track name") }
        guard let singer = json["singer"] as? String    else { fatalError("Can not get video track singer") }
        guard let avatar = json["image"] as? String     else { fatalError("Can not get video track image") }
        guard let url = json["location"] as? String     else { fatalError("Can not get video track location") }
        
        self.init(id: id, name: name, singer: singer, avatar: avatar, url: url)
    }
}

extension VideoTrack: Equatable {
    
    static func == (lhs: VideoTrack, rhs: VideoTrack) -> Bool {
        return lhs.id == rhs.id
    }
    
}
