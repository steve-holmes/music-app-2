//
//  SongRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SongRepository {
    
    func getSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    func resetSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    func getNextSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    
    func getSong(_ song: Song) -> Observable<Track>
    
}

class MASongRepository: SongRepository {
    
    let loader: SongLoader
    let cache: CategoryCache<SongInfo>
    var page = 1
    
    init(loader: SongLoader, cache: CategoryCache<SongInfo>) {
        self.loader = loader
        self.cache = cache
    }
    
    func getSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        page = 1
        return getSongs(on: category, at: page)
    }
    
    func resetSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        cache.removeItems(category: category)
        page = 1
        
        return getSongs(on: category, at: page)
    }
    
    func getNextSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        page += 1
        return getSongs(on: category, at: page)
    }
    
    func getSongs(on category: String, at page: Int) -> Observable<ItemResponse<SongInfo>> {
        if let songInfo = cache.getItem(category: category, page: page) {
            return .just(.item(songInfo))
        }
        
        return loader.getSongs(onCategory: category, at: page)
            .do(onNext: { [weak self] info in
                guard case let .item(songInfo) = info else { return }
                self?.cache.setItem(songInfo, category: category, page: page)
            })
    }
    
    func getSong(_ song: Song) -> Observable<Track> {
        return loader.getSong(song)
    }
    
}
