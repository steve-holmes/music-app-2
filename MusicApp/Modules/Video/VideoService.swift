//
//  VideoService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoService {
    
    var repository: VideoRepository { get }
    var category: CategoryRepository { get }
    var categoryCoordinator: CategoryCoordinator { get }
    
    // MARK: Repository
    
    func getVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    func resetVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    func getNextVideos(on category: String) -> Observable<ItemResponse<VideoInfo>>
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]>
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?>
    
}

class MAVideoService: VideoService {
    
    let repository: VideoRepository
    let category: CategoryRepository
    let categoryCoordinator: CategoryCoordinator
    
    init(repository: VideoRepository, category: CategoryRepository, categoryCoordinator: CategoryCoordinator) {
        self.repository = repository
        self.category = category
        self.categoryCoordinator = categoryCoordinator
    }
    
    // MARK: Repository
    
    func getVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        return repository.getVideos(on: category)
    }
    
    func resetVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        return repository.resetVideos(on: category)
    }
    
    func getNextVideos(on category: String) -> Observable<ItemResponse<VideoInfo>> {
        return repository.getNextVideos(on: category)
    }
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]> {
        return category.getVideos()
    }
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?> {
        return Observable.create() { observer in
            self.categoryCoordinator.presentCategories(category: category, infos: infos) { categoryInfo in
                if let info = categoryInfo { observer.onNext(info) }
                observer.onCompleted()
            }
            return Disposables.create()
        }    }
    
}
