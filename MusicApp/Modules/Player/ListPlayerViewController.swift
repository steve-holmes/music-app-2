//
//  ListPlayerViewController.swift
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

class ListPlayerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var store: PlayerStore!
    var action: PlayerAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension
        
        bindStore()
        bindAction()
    }
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<PlayerTrackSection> = {
        let dataSource = RxTableViewSectionedReloadDataSource<PlayerTrackSection>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, track in
            if self.store.track.value == track {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectedListCellPlayerCell.self), for: indexPath)
                
                if let selectedTrackCell = cell as? SelectedListCellPlayerCell {
                    selectedTrackCell.song = track.name
                    selectedTrackCell.singer = track.singer
                    selectedTrackCell.avatar = track.avatar
                }
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListPlayerCell.self), for: indexPath)
            
            if let trackCell = cell as? ListPlayerCell {
                trackCell.song = track.name
                trackCell.singer = track.singer
            }
            
            return cell
        }
        
        return dataSource
    }()

}

extension ListPlayerViewController {
    
    func bindStore() {
        store.tracks.asObservable()
            .map { [PlayerTrackSection(model: "Tracks", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.track.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension ListPlayerViewController {
    
    func bindAction() {
        tableView.rx.modelSelected(Track.self)
            .filter { [weak self] track in
                guard let this = self else { return false }
                return track != this.store.track.value
            }
            .subscribe(action.onTrackDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
