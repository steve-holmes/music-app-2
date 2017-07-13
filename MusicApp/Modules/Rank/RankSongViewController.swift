//
//  RankSongViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxDataSources
import NSObject_Rx

class RankSongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RankHeaderView!
    
    fileprivate var initialIndicatorView = InitialActivityIndicatorView()
    
    private let headerCell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
    
    var store: RankSongStore!
    var action: RankSongAction!
    
    // MARK: Properties
    
    var country: String!
    
    // MARK: Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        tableView.delegate = self
        
        headerView.configure(country: country, type: kRankTypeSong)
        headerView.configureAnimation(with: tableView)
        
        bindStore()
        bindAction()
    }
    
    private var headerViewNeedsToUpdate = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if headerViewNeedsToUpdate {
            headerView.frame.size.height = tableView.bounds.size.height / 4
            headerViewNeedsToUpdate = false
        }
    }
    
    // MARK: Target Actions
    
    @IBAction func backButtonTapped(_ backButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Data Sources
    
    fileprivate lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, Track>> = {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Track>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, track in
            if indexPath.section == 0 {
                return self.headerCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RankSongCell.self), for: indexPath)
            if let cell = cell as? RankSongCell {
                let contextAction = CocoaAction { [weak self] _ in
                    return self?.action.onContextButtonTap.execute((track.song, self)).map { _ in } ?? .empty()
                }
                cell.configure(name: track.name, singer: track.singer, contextAction: contextAction)
                cell.rank = indexPath.row + 1
            }
            return cell
        }
        
        return dataSource
    }()

}

extension RankSongViewController: UITableViewDelegate {
    
    private var headerHeight: CGFloat { return tableView.bounds.height / 4 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return headerHeight
        }
        return 44
    }
    
}

extension RankSongViewController {
    
    func bindStore() {
        store.tracks.asObservable()
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] _ in
                self?.initialIndicatorView.stopAnimating()
            })
            .map { tracks in [
                SectionModel(model: "Header", items: [
                    Track(id: "header", name: "Header", singer: "header", avatar: "not_found", lyric: "not_found", url: "not_found")
                ]),
                SectionModel(model: "Tracks", items: tracks)
            ]}
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(rx_disposeBag)
        
        store.tracks.asObservable()
            .filter { $0.count == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.initialIndicatorView.startAnimating(in: self?.view)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension RankSongViewController {
    
    func bindAction() {
        action.onLoad.execute(country)
        
        headerView.action = action.onPlayButtonPress()
        
        tableView.rx.modelSelected(Track.self)
            .subscribe(action.onTrackDidSelect.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
