//
//  RankService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankService {
    
    var repository: RankRepository { get }
    var coordinator: RankCoordinator { get }
    var categoryCoordinator: CategoryCoordinator { get }
    
    // MARK: Repository
    
    func getRank(on country: String) -> Observable<ItemResponse<RankInfo>>
    func resetRank(on country: String) -> Observable<ItemResponse<RankInfo>>
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]>
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?>
    
    func presentSong(country: String) -> Observable<Void>
    func presentPlaylist(_ playlists: [Playlist], country: String) -> Observable<Void>
    func presentVideo(_ videos: [Video], country: String) -> Observable<Void>
    
}

class MARankService: RankService {
    
    let repository: RankRepository
    let coordinator: RankCoordinator
    let categoryCoordinator: CategoryCoordinator
    
    init(repository: RankRepository, coordinator: RankCoordinator, categoryCoordinator: CategoryCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
        self.categoryCoordinator = categoryCoordinator
    }
    
    // MARK: Repository
    
    func getRank(on country: String) -> Observable<ItemResponse<RankInfo>> {
        return repository.getRank(on: country)
    }
    
    func resetRank(on country: String) -> Observable<ItemResponse<RankInfo>> {
        return repository.resetRank(on: country)
    }
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]> {
        return .just([repository.categoriesInfo])
    }

    // MARK: Coodinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?> {
        return .create() { observer in
            self.categoryCoordinator.presentCategories(category: category, infos: infos) { categoryInfo in
                if let info = categoryInfo { observer.onNext(info) }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func presentSong(country: String) -> Observable<Void> {
        return coordinator.presentSong(country: country)
    }
    
    func presentPlaylist(_ playlists: [Playlist], country: String) -> Observable<Void> {
        return coordinator.presentPlaylist(playlists, country: country)
    }
    
    func presentVideo(_ videos: [Video], country: String) -> Observable<Void> {
        return coordinator.presentVideo(videos, country: country)
    }
    
}
