//
//  PlayerStorage.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/23/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

class PlayerStorage {
    
    enum Position {
        case list
        case information
        case lyric
    }
    
    var position: Position = .information
    
    static let shared = PlayerStorage()
    
}
