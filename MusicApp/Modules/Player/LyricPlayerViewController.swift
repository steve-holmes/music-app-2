//
//  LyricPlayerViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/23/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class LyricPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLyricView: UIView!
    @IBOutlet weak var autoScrollingView: LyricAutoScrollingView!
    @IBOutlet weak var pasteboardView: LyricCopyingView!
    
    var store: PlayerStore!
    var action: PlayerAction!
    
    var lyricStore: LyricStore!
    var lyricAction: LyricAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        pasteboardView.configure(store: lyricStore)
        
        bindStore()
        bindAction()
    }
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, lyric in
            if indexPath.row == self.lyricStore.index.value {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectedLyricCell.self), for: indexPath)
                (cell as? SelectedLyricCell)?.lyric = lyric
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LyricCell.self), for: indexPath)
            (cell as? LyricCell)?.lyric = lyric
            return cell
        }
        
        return dataSource
    }()

}

extension LyricPlayerViewController {
    
    func bindStore() {
        lyricStore.lyrics.asObservable()
            .map { lyrics in lyrics.map { $0.content } }
            .map { [SectionModel(model: "Lyrics", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        lyricStore.lyrics.asObservable()
            .filter { $0.count > 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            })
            .addDisposableTo(rx_disposeBag)
        
        lyricStore.lyrics.asObservable()
            .map { $0.count > 0 }
            .bind(to: emptyLyricView.rx.isHidden)
            .addDisposableTo(rx_disposeBag)
        
        lyricStore.index.asObservable()
            .filter { [weak self] _ in (self?.lyricStore.lyrics.value.count ?? 0) > 0 }
            .subscribe(onNext: { [weak self] lyricIndex in
                self?.tableView.reloadData()
                let lyricIndexPath = IndexPath(row: lyricIndex, section: 0)
                self?.tableView.scrollToRow(at: lyricIndexPath, at: .middle, animated: true)
            })
            .addDisposableTo(rx_disposeBag)
        
        lyricStore.autoScrolling.asObservable()
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: autoScrollingView.rx.isHighlighted)
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension LyricPlayerViewController {
    
    func bindAction() {
        store.track.asObservable()
            .skip(1)
            .distinctUntilChanged()
            .map { track in track.lyric }
            .subscribe(onNext: { [weak self] lyricURL in
                self?.lyricAction.onLoad.execute(lyricURL)
            })
            .addDisposableTo(rx_disposeBag)
        
        store.currentTime.asObservable()
            .filter { [weak self] _ in self?.lyricStore.autoScrolling.value ?? true }
            .map { [weak self] currentTime -> Int? in
                self?.lyricStore.lyrics.value.index(where: { lyric in
                    lyric.time == currentTime
                })
            }
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { [weak self] index in
                self?.lyricAction.onLyricIndexChange.execute(index)
            })
            .addDisposableTo(rx_disposeBag)
        
        autoScrollingView.mutateAction = lyricAction.onLyricAutoScrollingChange()
    }
    
}
