//
//  VideoRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoRepository {
    
    func getVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    func resetVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    func getNextVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    
}

class MAVideoRepository: VideoRepository {
    
    let loader: VideoLoader
    let cache: CategoryCache<VideoInfo>
    var page = 1
    
    init(loader: VideoLoader, cache: CategoryCache<VideoInfo>) {
        self.loader = loader
        self.cache = cache
    }
    
    func getVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        page = 1
        return getVideos(on: category, at: page)
    }
    
    func resetVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        cache.removeItems(category: category)
        
        page = 1
        return getVideos(on: category, at: page)
    }
    
    func getNextVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        page += 1
        return getVideos(on: category, at: page)
    }
    
    func getVideos(on category: String, at page: Int) -> Observable<ItemResponse<VideoInfo>> {
        if let videoInfo = cache.getItem(category: category, page: page) {
            return .just(.item(videoInfo))
        }
        
        return loader.getVideos(onCategory: category, at: page)
            .do(onNext: { [weak self] info in
                guard case let .item(videoInfo) = info else { return }
                self?.cache.setItem(videoInfo, category: category, page: page)
            })
    }
    
}
