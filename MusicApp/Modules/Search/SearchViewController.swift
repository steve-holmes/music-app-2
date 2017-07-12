//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class SearchViewController: SegmentedPagerTabStripViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyView: UIView!
    
    weak var searchController: UISearchController!
    
    var store: SearchStore!
    var action: SearchAction!
    
    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchGeneralController()
        
        bindStore()
        bindAction()
    }
    
    private func configureSearchGeneralController() {
        guard let generalController = controllers.first as? SearchGeneralViewController else { return }
        
        generalController.moveToSongAction = CocoaAction { [weak self] in
            self?.moveToViewController(at: 1, animated: true)
            return .empty()
        }
        
        generalController.moveToPlaylistAction = CocoaAction { [weak self] in
            self?.moveToViewController(at: 2, animated: true)
            return .empty()
        }
        
        generalController.moveToVideoAction = CocoaAction { [weak self] in
            self?.moveToViewController(at: 3, animated: true)
            return .empty()
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return controllers
    }

}

extension SearchViewController {
    
    func bindStore() {
        bindHistories()
    }
    
    private func bindHistories() {
        store.histories.asObservable()
            .bind(to: historyTableView.rx.items(cellIdentifier: "SearchHistoryCell", cellType: SearchHistoryCell.self)) { _, content, cell in
                cell.content = content
            }
            .disposed(by: rx_disposeBag)
        
        let songs = store.songs.asObservable()
        let playlists = store.playlists.asObservable()
        let videos = store.videos.asObservable()
        
        Observable
            .combineLatest(songs, playlists, videos) { songs, playlists, videos in
                songs.count + playlists.count + videos.count
            }
            .map { count in count > 0 }
            .bind(to: historyView.rx.isHidden)
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension SearchViewController {
    
    func bindAction() {
        searchController.searchBar.rx.text.orEmpty
            .filter { $0.characters.count > 2 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.action.searchTextChange.execute(text)
            })
            .addDisposableTo(rx_disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .filter { $0.characters.count <= 2 }
            .subscribe(onNext: { [weak self] text in
                self?.action.searchTextClear.execute(())
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}
