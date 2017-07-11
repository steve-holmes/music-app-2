//
//  Lyric.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct Lyric {
    let time: Int
    let content: String
}

extension Lyric: Equatable {
    
    static func == (lhs: Lyric, rhs: Lyric) -> Bool {
        return lhs.time == rhs.time
    }
    
}

extension Lyric: Comparable {
    
    static func < (lhs: Lyric, rhs: Lyric) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func <= (lhs: Lyric, rhs: Lyric) -> Bool {
        return lhs.time <= rhs.time
    }
    
    static func > (lhs: Lyric, rhs: Lyric) -> Bool {
        return lhs.time > rhs.time
    }
    
    static func >= (lhs: Lyric, rhs: Lyric) -> Bool {
        return lhs.time >= rhs.time
    }
    
}
