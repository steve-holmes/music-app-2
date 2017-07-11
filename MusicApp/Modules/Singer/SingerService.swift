//
//  SingerService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerService {
    
    var repository: SingerRepository { get }
    var category: CategoryRepository { get }
    var coordinator: SingerCoordinator { get }
    var categoryCoordinator: CategoryCoordinator { get }
    
    // MARK: Repository
    
    func getSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    func resetSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    func getNextSingers(on category: String) -> Observable<ItemResponse<SingerInfo>>
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]>
    
    // MARK: Coordinator
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo]) -> Observable<CategoryInfo?>
    
    func presentSingerDetail(_ singer: Singer, category: String, index: Int) -> Observable<Void>
    func registerSingerPreview(in view: UIView) -> Observable<Void>
    
}

class MASingerService: SingerService {
    
    let repository: SingerRepository
    let category: CategoryRepository
    let coordinator: SingerCoordinator
    let categoryCoordinator: CategoryCoordinator
    
    init(repository: SingerRepository, category: CategoryRepository, coordinator: SingerCoordinator, categoryCoordinator: CategoryCoordinator) {
        self.repository = repository
        self.category = category
        self.coordinator = coordinator
        self.categoryCoordinator = categoryCoordinator
    }
    
    // MARK: Repository
    
    func getSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        return repository.getSingers(on: category)
    }
    
    func resetSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        coordinator.removeSingerDetailInfos(category: category)
        return repository.resetSingers(on: category)
    }
    
    func getNextSingers(on category: String) -> Observable<ItemResponse<SingerInfo>> {
        return repository.getNextSingers(on: category)
    }
    
    // MARK: Category
    
    func getCategories() -> Observable<[CategoriesInfo]> {
        return category.getSingers()
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
    
    func presentSingerDetail(_ singer: Singer, category: String, index: Int) -> Observable<Void> {
        return coordinator.presentSingerDetail(singer, category: category, index: index)
    }
    
    func registerSingerPreview(in view: UIView) -> Observable<Void> {
        return coordinator.registerSingerPreview(in: view)
    }
    
}
