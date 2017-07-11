//
//  Song.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxDataSources

struct Song {
    let id: String
    let name: String
    let singer: String
    
    init(id: String, name: String, singer: String) {
        self.id = id
        self.name = name
        self.singer = singer
    }
    
    init(json: [String:Any]) {
        guard let id = json["id"] as? String            else { fatalError("Can not get song id") }
        guard let name = json["name"] as? String        else { fatalError("Can not get song name") }
        guard let singer = json["singer"] as? String    else { fatalError("Can not get song singer") }
        
        self.init(id: id, name: name, singer: singer)
    }
}

extension Song: Equatable {}

func ==(lhs: Song, rhs: Song) -> Bool {
    return lhs.id == rhs.id
}
