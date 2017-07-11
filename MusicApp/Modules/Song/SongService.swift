//
//  SongService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SongService {
    
    var repository: SongRepository { get }
    var category: CategoryRepository { get }
    var notification: SongNotification { get }
    var coordinator: SongCoordinator { get }
    var categoryCoordinator: CategoryCoordinator { get }
    
    // MARK: Repository
    
    func getSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    func resetSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    func getNextSongs(on category: String) -> Observable<ItemResponse<SongInfo>>
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]>
    
    // MARK: Notification
    
    func play(_ song: Song) -> Observable<Void>
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?>
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void>
    
}

class MASongService: SongService {
    
    let repository: SongRepository
    let category: CategoryRepository
    let notification: SongNotification
    let coordinator: SongCoordinator
    let categoryCoordinator: CategoryCoordinator
    
    init(repository: SongRepository, category: CategoryRepository, notification: SongNotification, coordinator: SongCoordinator, categoryCoordinator: CategoryCoordinator) {
        self.repository = repository
        self.category = category
        self.notification = notification
        self.coordinator = coordinator
        self.categoryCoordinator = categoryCoordinator
    }
    
    // MARK: Repository
    
    func getSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        return repository.getSongs(on: category)
    }
    
    func resetSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        return repository.resetSongs(on: category)
    }
    
    func getNextSongs(on category: String) -> Observable<ItemResponse<SongInfo>> {
        return repository.getNextSongs(on: category)
    }
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]> {
        return category.getSongs()
    }
    
    // MARK: Music Center
    
    func play(_ song: Song) -> Observable<Void> {
        return notification.play(song)
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
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void> {
        return coordinator.openContextMenu(song, in: controller)
    }
    
}
