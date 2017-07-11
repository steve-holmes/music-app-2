//
//  RankRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankRepository {
    
    func getRank(on country: String) -> Observable<ItemResponse<RankInfo>>
    func resetRank(on country: String) -> Observable<ItemResponse<RankInfo>>
    
    var categoriesInfo: CategoriesInfo { get }
    
}

class MARankRepository: RankRepository {
    
    let loader: RankLoader
    let cache: ItemCache<RankInfo>
    
    init(loader: RankLoader, cache: ItemCache<RankInfo>) {
        self.loader = loader
        self.cache = cache
    }
    
    func getRank(on country: String) -> Observable<ItemResponse<RankInfo>> {
        if let rankInfo = cache.getItem(country) {
            return .just(.item(rankInfo))
        }
        return getRank(country: country)
    }
    
    func resetRank(on country: String) -> Observable<ItemResponse<RankInfo>> {
        cache.removeItem(country)
        return getRank(country: country)
    }
    
    func getRank(country: String) -> Observable<ItemResponse<RankInfo>> {
        return loader.getRank(on: country)
            .map { [weak self] response in
                guard let `self` = self else { return .loading }
                guard let category = self.categoriesInfo.categories.first(where: { $0.newlink == country }) else { return .loading }
                guard case let .item(rankResponse) = response else { return .loading }
                
                let (songs, playlists, videos) = rankResponse
                let info = CategoryInfo(name: category.name, new: true, newlink: country, hotlink: country)
                
                return .item(RankInfo(category: info, songs: songs, playlists: playlists, videos: videos))
            }
            .do(onNext: { [weak self] info in
                guard case let .item(rankInfo) = info else { return }
                self?.cache.setItem(rankInfo, for: country)
            })
    }
    
    fileprivate(set) lazy var categoriesInfo: CategoriesInfo = {
        return CategoriesInfo(name: "BXH", categories: [
            Category(name: "Việt Nam", newlink: kRankCountryVietnam, hotlink: kRankCountryVietnam),
            Category(name: "Âu Mỹ", newlink: kRankCountryEurope, hotlink: kRankCountryEurope),
            Category(name: "Hàn Quốc", newlink: kRankCountryKorea, hotlink: kRankCountryKorea)
        ])
    }()

}
