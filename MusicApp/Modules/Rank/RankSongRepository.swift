//
//  RankSongRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankSongRepository {
    
    func getTracks(on country: String) -> Observable<[Track]>
    
}

class MARankSongRepository: RankSongRepository {
    
    let loader: RankSongLoader
    let cache = ItemCache<[Track]>()
    
    init(loader: RankSongLoader) {
        self.loader = loader
    }
    
    func getTracks(on country: String) -> Observable<[Track]> {
        if let tracks = cache.getItem(country) {
            return .just(tracks)
        }
        
        return loader.getTracks(on: country)
            .do(onNext: { [weak self] tracks in
                self?.cache.setItem(tracks, for: country)
            })
    }
    
}
