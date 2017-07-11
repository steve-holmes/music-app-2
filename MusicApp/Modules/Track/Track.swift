//
//  Track.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Track {
    
    let id: String
    let name: String
    let singer: String
    let avatar: String
    let lyric: String
    let url: String
    
    init(id: String, name: String, singer: String, avatar: String, lyric: String, url: String) {
        self.id = id
        self.name = name
        self.singer = singer
        self.avatar = avatar
        self.lyric = lyric
        self.url = url
    }
    
    init(json: [String:Any]) {
        guard let id = json["id"] as? String                else { fatalError("Can not get Track id") }
        guard let name = json["name"] as? String            else { fatalError("Can not get Track name") }
        guard let singer = json["singer"] as? String        else { fatalError("Can not get Track singer") }
        guard let avatar = json["avatar"] as? String        else { fatalError("Can not get Track avatar") }
        guard let lyric = json["lyric"] as? String          else { fatalError("Can not get Track lyric") }
        guard let url = json["url"] as? String              else { fatalError("Can not get Track url") }
        
        self.init(id: id, name: name, singer: singer, avatar: avatar, lyric: lyric, url: url)
    }
    
}

extension Track: Equatable {
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
    
}
