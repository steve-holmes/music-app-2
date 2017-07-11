//
//  SingerRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerRepository {
    
    func getSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    func resetSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    func getNextSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    
    func getSinger(_ singer: Singer) -> Observable<(songs: [Song], playlists: [Playlist], videos: [Video])>
    
}

class MASingerRepository: SingerRepository {
    
    let loader: SingerLoader
    let cache: CategoryCache<SingerInfo>
    let categoryRepository: CategoryRepository
    
    var page = 1
    
    init(loader: SingerLoader, cache: CategoryCache<SingerInfo>, categoryRepository: CategoryRepository) {
        self.loader = loader
        self.cache = cache
        self.categoryRepository = categoryRepository
    }
    
    func getSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        page = 1
        return getSingers(on: category, at: page)
    }
    
    func resetSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        cache.removeItems(category: category)
        page = 1
        
        return getSingers(on: category, at: page)
    }
    
    func getNextSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        page += 1
        return getSingers(on: category, at: page)
    }
    
    func getSingers(on category: String, at page: Int) -> Observable<ItemResponse<SingerInfo>> {
        if let singerInfo = cache.getItem(category: category, page: page) {
            return .just(.item(singerInfo))
        }
        
        let hotCategoryInfo = CategoryInfo(name: "HOT", new: true, newlink: "", hotlink: "")
        
        if category.isEmpty && page == 1 {
            return loader.getHotSingers()
                .map { response -> ItemResponse<SingerInfo> in
                    switch response {
                    case .loading: return .loading
                    case .item(let singers): return .item(SingerInfo(category: hotCategoryInfo, singers: singers))
                    }
                }
        }
        
        if category.isEmpty {
            return .just(.item(SingerInfo(category: hotCategoryInfo, singers: [])))
        }
        
        return loader.getSingers(on: category, at: page)
            .map { [weak self] response -> ItemResponse<SingerInfo> in
                switch response {
                case .loading: return .loading
                case .item(let singers):
                    let link = category
                    
                    guard let categories = self?.categoryRepository.singers.categories else { return .loading }
                    guard let category = categories.first(where: { $0.newlink == link }) else { return .loading }
                    
                    let categoryInfo = CategoryInfo(category: category, new: true)
                    return .item(SingerInfo(category: categoryInfo, singers: singers))
                }
            }
            .do(onNext: { [weak self] info in
                guard case let .item(singerInfo) = info else { return }
                self?.cache.setItem(singerInfo, category: category, page: page)
            })
    }
    
    func getSinger(_ singer: Singer) -> Observable<(songs: [Song], playlists: [Playlist], videos: [Video])> {
        return loader.getSinger(singer)
    }
    
}
