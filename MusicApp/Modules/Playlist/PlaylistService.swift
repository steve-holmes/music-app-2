//
//  PlaylistService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistService {
    
    var repository: PlaylistRepository { get }
    var category: CategoryRepository { get }
    var coordinator: PlaylistCoordinator { get }
    var categoryCoordinator: CategoryCoordinator { get }
    var notification: PlaylistNotification { get }
    
    // MARK: Repository
    
    func getPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    func resetPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    func getNextPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]>
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?>
    
    func presentPlaylistDetail(_ playlist: Playlist, category: String, index: Int) -> Observable<Void>
    func registerPlaylistPreview(in view: UIView) -> Observable<Void>
    
    // MARK: Notification
    
    func play(_ playlist: Playlist) -> Observable<Void>
    
}

class MAPlaylistService : PlaylistService {
    
    let repository: PlaylistRepository
    let category: CategoryRepository
    let coordinator: PlaylistCoordinator
    let categoryCoordinator: CategoryCoordinator
    let notification: PlaylistNotification
    
    init(repository: PlaylistRepository, category: CategoryRepository, coordinator: PlaylistCoordinator, categoryCoordinator: CategoryCoordinator, notification: PlaylistNotification) {
        self.repository = repository
        self.category = category
        self.coordinator = coordinator
        self.categoryCoordinator = categoryCoordinator
        self.notification = notification
    }
    
    // MARK: Repository
    
    func getPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        return repository.getPlaylists(on: category)
    }
    
    func resetPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        coordinator.removePlaylistDetailInfos(category: category)
        return repository.resetPlaylists(on: category)
    }
    
    func getNextPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        return repository.getNextPlaylists(on: category)
    }
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]> {
        return category.getPlaylists()
    }
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?> {
        return Observable.create() { observer in
            self.categoryCoordinator.presentCategories(category: category, infos: infos) { categoryInfo in
                if let info = categoryInfo { observer.onNext(info) }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func presentPlaylistDetail(_ playlist: Playlist, category: String, index: Int) -> Observable<Void> {
        return coordinator.presentPlaylistDetail(playlist, category: category, index: index)
    }
    
    func registerPlaylistPreview(in view: UIView) -> Observable<Void> {
        return coordinator.registerPlaylistPreview(in: view)
    }
    
    // MARK: Music Center
    
    func play(_ playlist: Playlist) -> Observable<Void> {
        return notification.play(playlist)
    }
    
}
