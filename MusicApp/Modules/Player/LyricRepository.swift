//
//  LyricRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol LyricRepository {
    
    func load(_ url: String) -> Observable<[Lyric]>
    
}

class MALyricRepository: LyricRepository {
    
    let loader: LyricLoader
    let cache = ItemCache<[Lyric]>()
    
    init(loader: LyricLoader) {
        self.loader = loader
    }
    
    func load(_ url: String) -> Observable<[Lyric]> {
        if let lyrics = cache.getItem(url) {
            return .just(lyrics)
        }
        
        return loader.load(url)
            .do(onNext: { [weak self] lyrics in
                if lyrics.count > 0 {
                   self?.cache.setItem(lyrics, for: url)
                }
            })
    }
    
}
