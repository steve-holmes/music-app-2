//
//  LyricStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol LyricStore {
    
    var lyrics: Variable<[Lyric]> { get }
    var index: Variable<Int> { get }
    var autoScrolling: Variable<Bool> { get }
    
}

class MALyricStore: LyricStore {
    
    let lyrics = Variable<[Lyric]>([])
    let index = Variable<Int>(0)
    let autoScrolling = Variable<Bool>(true)
    
}
