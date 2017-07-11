//
//  MusicMode.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

enum MusicMode {
    case flow
    case `repeat`
    case repeatOne
    case shuffle
    
    var next: MusicMode {
        switch self {
        case .flow:         return .repeat
        case .repeat:       return .repeatOne
        case .repeatOne:    return .shuffle
        case .shuffle:      return .flow
        }
    }
}
